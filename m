Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AB8ffV088433 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 06:08:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C99FA2E553C
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 04:09:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9cawdY4F5Jqe0B0w for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 04:09:02 -0700 (PDT)
Date: Wed, 10 Jun 2009 07:09:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_growfs doesn't grow on 2TB raid
Message-ID: <20090610110902.GA19633@infradead.org>
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
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
To: jack the ripper <evil_metalpeet@hotmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 10, 2009 at 12:52:01PM +0200, jack the ripper wrote:
> 		  RoSe linux # zgrep -i efi /proc/config.gz
> 
> 
> CONFIG_EFI=y
> CONFIG_FB_EFI=y
> CONFIG_EFI_VARS=y
> CONFIG_EFI_PARTITION=y	

Do you have CONFIG_LBD set?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
