Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40F797F53
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 04:41:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A8AC8F8065
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:41:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Uaq0P5CiVoU0g7Zn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 Nov 2013 02:41:16 -0800 (PST)
Date: Thu, 28 Nov 2013 02:41:15 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/3] xfs:  fix quota related problems
Message-ID: <20131128104115.GD26927@infradead.org>
References: <5294A449.9010202@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5294A449.9010202@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Nov 26, 2013 at 09:38:17PM +0800, Jeff Liu wrote:
> Since the infinite loop and assertion issue are failed due to different issues, I
> wonder if we'd better to add two test cases to cover them separately or not? i.e,
> One sanity check to verify turning group/project off quota with user quota is active,
> another test to verify turning group/project quota off with fsstress is running.

I always prefer to have isolated cases for bugs that are trivially
reprodible instead of relying on heavy stress tests with multiple
components. Vote for two test cases from me!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
