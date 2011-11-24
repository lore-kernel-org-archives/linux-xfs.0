Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAOJonPi037924 for <xfs@oss.sgi.com>; Thu, 24 Nov 2011 13:50:49 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B8F5419C45B4
	for <xfs@oss.sgi.com>; Thu, 24 Nov 2011 11:50:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Afz75FecaA0wowxP for
	<xfs@oss.sgi.com>; Thu, 24 Nov 2011 11:50:48 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAOJokU5029855
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 24 Nov 2011 14:50:46 -0500
Received: from andromeda.usersys.redhat.com (ovpn-113-40.phx2.redhat.com
	[10.3.113.40])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id pAOJog6X011570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 24 Nov 2011 14:50:45 -0500
Date: Thu, 24 Nov 2011 17:50:42 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
Message-ID: <20111124195042.GA3671@andromeda.usersys.redhat.com>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
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
To: xfs@oss.sgi.com

On Thu, Nov 24, 2011 at 05:20:51PM -0200, Carlos Maiolino wrote:
> xfsprogs (mainly mkfs) is using the logical sector size of a volume to initialize
> the filesystem, which, even in devices using Advanced Format, it can get a 512
> bytes sector size if it is set as the logical sector size.
> This patch changes the ioctl to get the physical sector size, independent of the
> logical size.
> 

Just as information, this patch proposal does not change the behaviour of mkfs in case the 
user is using libblkid, which in case, mkfs will take advantage of libblkid to retrieve disk
topology and information.
I'm not sure if libblkid is the best way to retrieve the device sector's size here, since 
this does not provide a way to retrive the physical sector size, only the logical size, but 
I can be very wrong.

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
