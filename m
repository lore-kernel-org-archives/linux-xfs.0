Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4D457F37
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2015 01:50:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FB3D8F8070
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 23:50:14 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id gTmCLXmZvJBwmb32 for
	<xfs@oss.sgi.com>; Thu, 19 Mar 2015 23:50:12 -0700 (PDT)
Date: Fri, 20 Mar 2015 07:50:10 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150320065010.GC626@lst.de>
References: <20150304020826.GD19439@fieldses.org>
	<20150304155421.GE1627@fieldses.org>
	<20150304220900.GX18360@dastard>
	<20150304222709.GI1627@fieldses.org>
	<20150304224557.GY4251@dastard> <54F78BE5.1020608@sandeen.net>
	<20150304225623.GZ4251@dastard>
	<20150305040849.GJ1627@fieldses.org>
	<20150305131731.GA16235@lst.de>
	<CAB6yy341fvF8Bsg0_hViQm+zRLVdJ2WOE9duDwdU+S0CkOEpbg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAB6yy341fvF8Bsg0_hViQm+zRLVdJ2WOE9duDwdU+S0CkOEpbg@mail.gmail.com>
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
To: Kinglong Mee <kinglongmee@gmail.com>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>

On Fri, Mar 20, 2015 at 12:06:18PM +0800, Kinglong Mee wrote:
> Maybe you want adding "trace_layout_recall_fail(&ls->ls_stid.sc_stateid);" here?
> I think the following is better,

It is!  That's indeed what I had in my old trees before the big rebase.

Can you write up a small changelog and add a signoff?

Thanks a lot!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
