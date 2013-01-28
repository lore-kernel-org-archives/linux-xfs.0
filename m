Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 196F57F69
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 15:31:31 -0600 (CST)
Date: Mon, 28 Jan 2013 15:31:27 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2 V2] xfs_logprint: Handle multiply-logged inode fields
Message-ID: <20130128213127.GD27055@sgi.com>
References: <5092A1DE.10609@redhat.com> <5092A2B6.2000907@redhat.com>
	<5092A46A.8080909@sandeen.net> <20130122175530.GR27055@sgi.com>
	<20130122210511.GK2498@dastard> <5106E3EE.2030601@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5106E3EE.2030601@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jan 28, 2013 at 02:47:42PM -0600, Eric Sandeen wrote:
> On 1/22/13 3:05 PM, Dave Chinner wrote:
> > On Tue, Jan 22, 2013 at 11:55:30AM -0600, Ben Myers wrote:
> >> Hey Eric,
> >>
> >> On Thu, Nov 01, 2012 at 11:33:46AM -0500, Eric Sandeen wrote:
> >>> As xlog_print_trans_inode() stands today, it will error
> >>> out if more than one flag is set on f->ilf_fields:
> >>>
> >>> 	xlog_print_trans_inode: illegal inode type
> >>>
> >>> but this is a perfectly valid case, to have i.e. a data and
> >>> an attr flag set.
> >>>
> >>> Following is a pretty big reworking of the function to
> >>> handle more than one field type set.
> >>
> >> I'm trying to wrap my head around this one.  I have a few stupid questions.
> >>
> >>> I've tested this by a simple test such as creating one
> >>> file on an selinux box, so that data+attr is set, and
> >>> logprinting; I've also tested by running logprint after
> >>> subsequent xfstest runs (although we hit other bugs that
> >>> way).
> >>>
> >>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >>> ---
> 
> Ben, Mark -
> 
> Where are we at with this one?  We have a partner who is interested in the fix.
> Do you want anything more from me before it can be merged?

Hey Eric,

I think it's ready to be merged... It looks like you reposted Jan 02 and I
replied to the wrong one.  If that code isn't significantly different we're
good to go.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
