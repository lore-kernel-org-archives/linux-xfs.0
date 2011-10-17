Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HCPOKJ259661 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 07:25:24 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B7E961C90B3D
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 05:25:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QrDJEuxIB7ctzT4P for
	<xfs@oss.sgi.com>; Mon, 17 Oct 2011 05:25:23 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9HCPM11025253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 08:25:22 -0400
Received: from andromeda.usersys.redhat.com ([10.3.113.8])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p9HCPJ6x013222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 08:25:22 -0400
Date: Mon, 17 Oct 2011 10:24:12 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: Fix possible memory corruption in xfs_readlink
Message-ID: <20111017122412.GA32608@andromeda.usersys.redhat.com>
References: <20111016234121.GS3159@dastard>
	<1318863168-3187-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318863168-3187-1-git-send-email-cmaiolino@redhat.com>
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

Hi,

On Mon, Oct 17, 2011 at 12:52:48PM -0200, Carlos Maiolino wrote:
> This patch fix a possible memory corruption when
> the link is larger than MAXPATHLEN and XFS_DEBUG
> is not enabled. This also uses S_IFLNK to check
> link not only in DEBUG mode.
> 

please, disconsider this last patch. I did two mistakes here and
I'll be sending a fixed version of it.
My apologies for this

-- 
--Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
