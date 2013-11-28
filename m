Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E20497F51
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 08:39:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7DC19AC006
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 06:39:41 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id tUhELRNGIUAR7uLF (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 06:39:40 -0800 (PST)
Date: Thu, 28 Nov 2013 06:39:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/4] xfs: add O_TMPFILE support
Message-ID: <20131128143938.GA20409@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<20131128103549.GA26927@infradead.org>
	<CAEH94LhyKoOhaUG1ToomqT_LnxG1rxcTJ2WK3D2N_Eu7pgKQhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEH94LhyKoOhaUG1ToomqT_LnxG1rxcTJ2WK3D2N_Eu7pgKQhQ@mail.gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

> ok, i will try to run xfstests before real submission is done.

There's no coverage of O_TMPFILE yet, but we do need it if we want
to support the feature.  

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
