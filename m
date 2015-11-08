Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D85B7F52
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 15:52:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C37C8AC001
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 13:52:46 -0800 (PST)
Received: from achernar.gro-tsen.net (achernar.gro-tsen.net [195.154.91.68])
	by cuda.sgi.com with ESMTP id ND5kWfl57FFko8fQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Nov 2015 13:52:43 -0800 (PST)
Date: Sun, 8 Nov 2015 22:52:41 +0100
From: David Madore <david+ml@madore.org>
Subject: Re: XFS freeze (xfsaild blocked) with 4.2.5 (also 4.3)
Message-ID: <20151108215241.GA10569@achernar.madore.org>
References: <20151108114917.GA5620@achernar.madore.org>
	<20151108164941.GA26354@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151108164941.GA26354@infradead.org>
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
Cc: Linux Kernel mailing-list <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Nov 08, 2015 at 08:49:41AM -0800, Christoph Hellwig wrote:
> can you try the patch at:
> 
> http://article.gmane.org/gmane.comp.file-systems.xfs.general/70984
> 
> The symptoms sound surprisingly similar.

Thanks for the pointer.  I'm running with the patch now, and will
follow-up if the problem reoccurs.

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
