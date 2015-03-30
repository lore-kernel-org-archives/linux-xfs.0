Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 659F07F37
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 09:06:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11087AC004
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 07:06:49 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id IkkAXG4nC1oNBrfz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Mar 2015 07:06:45 -0700 (PDT)
Date: Mon, 30 Mar 2015 07:06:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 3/3] NFSD: Add support for encoding multiple segments
Message-ID: <20150330140637.GA26244@infradead.org>
References: <OFB111A6D8.016B8BD5-ON88257E0D.001D174D-88257E0D.005268D6@us.ibm.com>
	<20150319153627.GA20852@fieldses.org>
	<OF38D4D18B.19055EC2-ON88257E0D.0059BA03-88257E0D.005A781F@us.ibm.com>
	<20150320151718.GD2036@fieldses.org>
	<20150320162303.GA18786@infradead.org>
	<20150320182621.GH2036@fieldses.org>
	<CAFX2JfkybBPcqD6A8r-jOkPnkL26=NEuK3zhA6TLn-DVam+kfQ@mail.gmail.com>
	<20150324174916.GA28906@infradead.org>
	<55142405.3090000@Netapp.com>
	<CAHQdGtTavsJ5k0taRCBi7CgP1NYjqQmgbQcE-yUkXQOKdQsGpA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHQdGtTavsJ5k0taRCBi7CgP1NYjqQmgbQcE-yUkXQOKdQsGpA@mail.gmail.com>
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
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Marc Eshel <eshel@us.ibm.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-nfs-owner@vger.kernel.org, Anna Schumaker <Anna.Schumaker@netapp.com>

On Thu, Mar 26, 2015 at 11:32:25AM -0400, Trond Myklebust wrote:
> So there is a clear win in the 100% hole case here, but otherwise the
> statistical fluctuations are dominating the numbers. Can you get us a
> little more stats and then perhaps run the results through nfsometer?

And that's just the uncached reads if I understand the thread correctly.
The cached case isn't uncommon in real life, so regressing it isn't
really an option either.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
