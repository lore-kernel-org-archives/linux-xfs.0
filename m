Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 56ECC7D16
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:44:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1BECF30404E
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 16:44:36 -0700 (PDT)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com
	[66.111.4.29]) by cuda.sgi.com with ESMTP id CUcCT3AKraGMEM67
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 16:44:34 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id C1ECF20B0B
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 19:44:33 -0400 (EDT)
Date: Mon, 2 May 2016 16:44:32 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: XFS hole punch races
Message-ID: <20160502234432.GB14806@kroah.com>
References: <20160322155740.GB28772@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160322155740.GB28772@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Tue, Mar 22, 2016 at 04:57:40PM +0100, Jan Kara wrote:
> Hi,
> 
> similarly to ext4 also XFS had races between hole punching and page faults
> which could result in data corruption. The fixes were merged in 4.1-rc1 but
> it might make sense to backport them to older stable releases given the
> nature of the issue.
> 
> Relevant fixes are:
> 
> de0e8c20ba3a65b0f15040aabbefdc1999876e6b
> 075a924d45cc69c75a35f20b4912b85aa98b180a
> e8e9ad42c1f1e1bfbe0e8c32c8cac02e9ebfb7ef
> 0f9160b444e4de33b65dfcd3b901358a3129461a
> 723cac48473358939759885a18e8df113ea96138
> ec56b1f1fdc69599963574ce94cc5693d535dd64

None of these apply to 3.14-stable, so I'm not going to worry about them
:)

thanks,

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
