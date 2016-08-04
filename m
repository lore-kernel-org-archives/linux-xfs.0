Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DAC6D7CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 18:23:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6FCADAC003
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 16:23:51 -0700 (PDT)
Received: from act-MTAout4.csiro.au (act-MTAout4.csiro.au [150.229.7.41]) by
	cuda.sgi.com with ESMTP id wCFIlKf1WumuADyS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Aug 2016 16:23:48 -0700 (PDT)
Date: Fri, 5 Aug 2016 09:23:43 +1000
From: Vincent McIntyre <vincent.mcintyre@csiro.au>
Subject: Re: Programmatically query default XFS Quota ?
Message-ID: <20160804232343.GC6606@ncpinstall.atnf.CSIRO.AU>
References: <839565DD1303AC4993B245FFDB34AF78510C9C8F@tur-exch-node1.massey.ac.nz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <839565DD1303AC4993B245FFDB34AF78510C9C8F@tur-exch-node1.massey.ac.nz>
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
To: "Rynhart, Patrick" <P.Rynhart@massey.ac.nz>
Cc: "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

On Thu, Aug 04, 2016 at 10:48:32PM +0000, Rynhart, Patrick wrote:
> Hi,
> 
> I can set a default quota on a file system as follows:
> 
> xfs_quota -x -c 'limit bsoft=100m bhard=100m -d' /home
> 
> But I'm not sure how to query this - can anyone advise ?

quotatool understands xfs quotas to some degree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
