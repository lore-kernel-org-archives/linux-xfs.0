Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5ECiYEv041033 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 07:44:34 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D0163C508B
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 05:47:09 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id XaOo1R6hExkVbrzT for <xfs@oss.sgi.com>;
	Mon, 14 Jun 2010 05:47:09 -0700 (PDT)
Date: Mon, 14 Jun 2010 14:46:49 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/8] Add test of quota accounting using fsx
Message-ID: <20100614124649.GF3903@quack.suse.cz>
References: <1274710459-11446-1-git-send-email-jack@suse.cz>
	<1274710459-11446-5-git-send-email-jack@suse.cz>
	<4C0FD43D.3040803@sandeen.net>
	<20100610105813.GB10827@quack.suse.cz>
	<4C1117F3.2010008@sandeen.net> <4C114E80.4050803@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C114E80.4050803@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 10-06-10 15:43:44, Eric Sandeen wrote:
> Eric Sandeen wrote:
> > Jan Kara wrote:
> >> On Wed 09-06-10 12:49:49, Eric Sandeen wrote:
> >>> Jan Kara wrote:
> >>>> Run fsx (and also several fsx threads in parallel) and verify that
> >>>> quota accounting is correct after they finish.
> >>> Jan, I'm having trouble with this one on XFS for some reason, with our 
> >>> RHEL6 kernel and quota-3.17...
> 
> These don't seem to be working properly at all with xfs.
> 
> In quota-3.17, quotaoff seems to turn off both accounting and enforcement,
> despite what the man page says - 
> 
>        To turn off quota limit enforcement on any XFS filesystem, first make sure
>        that quota accounting and enforcement are both turned on using repquota -v
>        filesystem.   Then,  use  quotaoff -v filesystem to disable limit enforce-
>        ment.  This may be done while the filesystem is mounted.
> 
> And once accounting is turned off, it can't be re-enabled without a remount.
> 
> With quota-4.0.0-preX, it seems to turn off -neither- accounting nor enforcement,
> based on hch's test:
> 
> [14:59]  <hch> qemu1:~/xfstests-dev# mount -o quota /dev/vdb5 /mnt/test
> [14:59]  <hch> qemu1:~/xfstests-dev# quotaon -f /dev/vdb5
> [15:00]  <hch> qemu1:~/xfstests-dev# quotaon /dev/vdb5
> [15:00]  <hch> quotaon: Enable XFS group quota accounting during mount
> [15:00]  <hch> quotaon: Enforcing user quota already on /dev/vdb5
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Argh ;)
  Ah, not many people seem to use quotaon(8) with XFS :). The fact that we
turned off both enforcement and accounting was originally intended I think
(Nathan Scott wrote the code) but I agree with you that it makes more sence
to turn off just enforcement as is stated in the manpage. The check in
quotaon.c:newstate() was buggy and worked only by luck for XFS. After I
fixed error checking of kern_quota_on the check stopped working...
  I have now committed changes to quota-tools and checked that quotaon now
works reasonably with XFS so it should be cleaned up hopefully.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
