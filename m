Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 08C607F6B
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 10:44:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8BD52AC002
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 08:44:08 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Kr8kpt2M8YwifVTP for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2015 08:44:06 -0800 (PST)
Message-ID: <54C27A55.5030701@sandeen.net>
Date: Fri, 23 Jan 2015 10:44:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Change sector size on existing partition
References: <54C246EC.90207@xtremenitro.org>
	<54C268ED.2000801@sandeen.net>	<54C26B5F.7000803@xtremenitro.org>
	<54C26D8F.1040402@sandeen.net> <54C2761C.4050208@xtremenitro.org>
In-Reply-To: <54C2761C.4050208@xtremenitro.org>
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
To: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>, xfs@oss.sgi.com

On 1/23/15 10:26 AM, Dewangga Bachrul Alam wrote:
> Hi,
> 
> Thanks for your kind, but I don't know how to reproduce the errors, it
> happens randomly. I try to reproduce on VM but nothing helps, I can't
> create raid array on VM. :)
> 
> But, I'm quite sure there is miscalculation or something else that make
> 4k sector size on RAID-10 array.

Well, as Brian mentioned in the other part of the thread, it's the logical
and physical sector sizes that matter.  mkfs.xfs simply acts on what the
device reports (i.e. the --getpbsz value).

If for some reason your RAID-10 array is reporting 4k/4k and you don't expect
that, you'll need to go digging through the block device configuration and
maybe ask questions of those communities, too.

It seems like you have interesting device stacking; use the blockdev command
to check logical & physical sector size at each layer starting at the disk
itself, and work your way up.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
