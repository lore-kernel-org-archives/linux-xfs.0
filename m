Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D8DE6802C
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 18:31:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C00AF304039
	for <xfs@oss.sgi.com>; Sun,  3 Mar 2013 16:31:37 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZwHXTixqQKdZ28Gf for <xfs@oss.sgi.com>;
	Sun, 03 Mar 2013 16:31:36 -0800 (PST)
Date: Mon, 4 Mar 2013 11:31:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: logsunit rounding causes iclog corruption/crash
Message-ID: <20130304003134.GJ23616@dastard>
References: <20130302201446.854313570@sgi.com>
	<20130302201452.236378200@sgi.com> <20130302230513.GH23616@dastard>
	<51339EC7.1000509@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51339EC7.1000509@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Sun, Mar 03, 2013 at 01:04:39PM -0600, Mark Tinguely wrote:
> On 03/02/13 17:05, Dave Chinner wrote:
> >On Sat, Mar 02, 2013 at 02:14:47PM -0600, Mark Tinguely wrote:
> >>When the iclog buffer size and log stripe unit are both defined and
> >>the log stripe unit is less the log buffer size then the buffer is
> >>rounded up to the log stripe unit size during the xlog_sync().
> >>
> >>This rounding can exceed the iclog buffer length and in xlog_data_pack():
> >>  1) Cause corruption inside the iclog buffer because there will not be
> >>     enough space for the headers in the front of the iclog buffer for
> >>     the rounding.
> >>  2) Cause corruption in memory that follows the iclog buffer when
> >>     stamping the lsn in each of the rounded blocks.
> >>  3) If CONFIG_XFS_DEBUG is defined will cause a crash in xlog_verify_iclog().
> >>  4) Cause page fault crash if the memory after the buffer is not mapped.
...
> >If the user has specified an invalid log buffer size, then reject it
> >with:
> >
> >logbsize XXX is not an integer multiple of the log stripe unit YYY
> >
> >Rounding means that the user isn't getting what they want and they
> >may not realise it. If they make a mistake, they should be informed
> >and forced to fix it before going any further.
> 
> The code already silently changes the log blocksize if
> mp->m_sb.sb_logsunit > mp->m_logbsize.

Where? It only changes m_logbsize if it is <= 0, which means the
user has not specified the value as a mount option and hence we are
free to chose whatever value we want.

> IMO, it should fix it not a multiple too.

ENOPARSE. :/

FWIW, a further argument against the rounding approach is this: the
iclogbuf size supplied to mount is constrainted to be a power of 2
size.

        if (mp->m_logbsize != -1 &&
            mp->m_logbsize !=  0 &&
            (mp->m_logbsize < XLOG_MIN_RECORD_BSIZE ||
             mp->m_logbsize > XLOG_MAX_RECORD_BSIZE ||
             !is_power_of_2(mp->m_logbsize))) {
                xfs_warn(mp,
                        "invalid logbufsize: %d [not 16k,32k,64k,128k or 256k]",
                        mp->m_logbsize);
                return XFS_ERROR(EINVAL);
        }

This constraint appears to be a feature of the original log stripe
unit code that did only support power-of-2 log stripe units.
However, that was removed way back in 2004:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=d3037d91429cc2ea383f8a2736c86ed9f1eec542

That commit introduced the very rounding code in xlog_sync() that is
causing the crash you are trying to address right now. i.e. this
code:

	count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));

IOWs, it makes no sense to only allow power-of-2 logbsize options if
we then round it to something completely different. The above commit
makes it pretty clear that the intent is that logbsize should be an
exact integer multiple of the log stripe unit - which it is if no
logbsize mount option is given - but our mount option parsing does
not reflect this at all.

Personally, I'd prefer that logbsize be limited to power-of-2
multiples of the lsunit or XLOG_MIN_RECORD_BSIZE (if lsunit = 0) as
allowing arbitrary values to be specified by users leads to a
testing and bug triage nightmare.

If we are not going to change the power-of-2 logbsize mount option
requirement, then I think that the correct solution is to make the
log limit the iclogbuf size internally to power-of-2 multiples of
the lsunit so that it is not at all externally visible (e.g.
/proc/self/mounts shows exactly what came in as a mount option).
This problem really has nothing to do with what mount options are
specified and passed to the log - the log is separate code with it's
own internal constraints and hence should be ensuring that it's
setup is consistent with those constraints....

Further, if we really need to know what iclogbuf size the log is
using on disk, both the physical iclogbuf size and the size of the
current write gets written into every log header block....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
