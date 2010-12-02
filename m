Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2CIwqS016629 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 06:18:59 -0600
Received: from mail-wy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F117160B89E
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 04:20:40 -0800 (PST)
Received: from mail-wy0-f181.google.com (mail-wy0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id gYCpgYZwl0MZ8qKW
	for <xfs@oss.sgi.com>; Thu, 02 Dec 2010 04:20:40 -0800 (PST)
Received: by wyf22 with SMTP id 22so8783778wyf.26
	for <xfs@oss.sgi.com>; Thu, 02 Dec 2010 04:20:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101026225839.GZ32255@dastard>
References: <AANLkTi=Zq3mh=0Q-g6oi-OqYFRsENiTjLcHfvPNsOkGa@mail.gmail.com>
	<20101026225839.GZ32255@dastard>
Date: Thu, 2 Dec 2010 12:20:39 +0000
Message-ID: <AANLkTim8yj8u0tDTxSC1MUrQ2H=xR58zmVnX+Yd+Q7rP@mail.gmail.com>
Subject: Re: Possible deadlock when deleting from realtime section
From: Denny Priebe <denny.priebe@googlemail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 26, 2010 at 10:58 PM, Dave Chinner <david@fromorbit.com> wrote:

> Hmmm. Looks like we broke recursive inode locking in
> xfs_trans_iget() in commit aa72a5cf00001d0b952c7c755be404b9118ceb2e
> ("xfs: simplify xfs_trans_iget").

> What we didn't take into account is multiple RT allocator calls in
> the same transaction context. Let me think about the best way to fix
> this.

Is there any news on this? Maybe some patch I could try out?

Regards,
Denny

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
