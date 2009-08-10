Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7A3gkqA031287 for <xfs@oss.sgi.com>; Sun, 9 Aug 2009 22:42:46 -0500
Received: from mail.vpac.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B639B3B71D2
	for <xfs@oss.sgi.com>; Sun,  9 Aug 2009 20:43:38 -0700 (PDT)
Received: from mail.vpac.org (mail.vpac.org [202.158.218.6]) by cuda.sgi.com
	with ESMTP id QACref8yaOW3OOEa for <xfs@oss.sgi.com>;
	Sun, 09 Aug 2009 20:43:38 -0700 (PDT)
Date: Mon, 10 Aug 2009 13:43:29 +1000 (EST)
From: Chris Samuel <csamuel@vpac.org>
Message-ID: <759036422.1055591249875809461.JavaMail.root@mail.vpac.org>
In-Reply-To: <7684694.1055541249875694469.JavaMail.root@mail.vpac.org>
Subject: Re: XFS filesystem shutting down on linux 2.6.28.10 (xfs_rename)
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com


----- "Chris Samuel" <csamuel@vpac.org> wrote:

> Happy to do that, though we won't be able to reboot into it
> until another crash fails (the impact on the HPC jobs is too
> large I'm afraid :-( ).

Unfortunately we had another failure on Saturday and after
getting some feedback from users we've had to regress to the
Debian 2.6.26-4 kernel (we avoided that initially because of
a separate issue, which appears solved now).

Of course it's possible that the issue still lurks in
this one, but we won't know for a little bit.

cheers!
Chris
-- 
Christopher Samuel - (03) 9925 4751 - Systems Manager
 The Victorian Partnership for Advanced Computing
 P.O. Box 201, Carlton South, VIC 3053, Australia
VPAC is a not-for-profit Registered Research Agency

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
