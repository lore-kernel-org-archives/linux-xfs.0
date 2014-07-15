Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FADB7F67
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 09:09:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C7BB8F806F
	for <xfs@oss.sgi.com>; Tue, 15 Jul 2014 07:09:44 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id K9lxMHtMRxFPZ8zJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Jul 2014 07:09:41 -0700 (PDT)
Date: Tue, 15 Jul 2014 16:09:38 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] logprint: Fix printing of AGF buffers
Message-ID: <20140715140938.GA1733@quack.suse.cz>
References: <1405349100-19734-1-git-send-email-jack@suse.cz>
	<20140715101931.GC30363@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140715101931.GC30363@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 15-07-14 03:19:31, Christoph Hellwig wrote:
> On Mon, Jul 14, 2014 at 04:45:00PM +0200, Jan Kara wrote:
> > Currently xfs_logprint doesn't show detailed data about AGF buffers and
> > instead always shows "Out of space". This is because xfs_agf_t has
> > additional fields and padding which we never read from disk and thus
> > buffer length is always smaller than the size of xfs_agf_t.
> > 
> > Fix the problem by only making sure we have enough data in the buffer
> > to contain all the information we want to print.
> 
> The fix looks correct to me, but te explanation should be more verbose:
> the reason why we don't read agf_uuid and above is because you're
> probably dumping a v4 filesystems which doesn't even have those fields.
  I'm actually dumping v5 filesystem. The issue is that with v5 filesystem
not all fields are logged (e.g. CRC isn't) and thus the length of logged
buffer is shorter than the length of in-memory structure.

> Its seems like various other fields have the same issue in logprint,
> and I also suspect we want some defines for the v4 size instead of using
> the offsetoff tricks.
  I had a look before I submitted this patch and I didn't find anything.
Now that I'm looking again, AGI buffers probably need a similar treatment.
Superblock buffers are already checked against fixed number so those don't
have a problem. Dquot buffers should be fine as well because those don't
have a checksum and other unlogged stuff. And I didn't find any other
structures in the log that would have the problem (please point me if I
missed something).

Regarding how to fix this cleanly - offsetof() seems like a reasonably
clean way to me. If you prefer to define number of bytes each buffer type
has to have in the log, I can do that as well. Or I could define
alternative structures only containing fields we need in the log so that we
can print info but this all seems like an additional complexity with
disputable gain...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
