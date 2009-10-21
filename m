Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LGS6aV011049 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 11:28:07 -0500
Message-ID: <4ADF36E3.8080801@sandeen.net>
Date: Wed, 21 Oct 2009 11:29:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage in XFS
References: <4ACB3AC5.4010603@vlnb.net> <20091006131020.GA12343@infradead.org>
In-Reply-To: <20091006131020.GA12343@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, Vladislav Bolkhovitin <vst@vlnb.net>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Oct 06, 2009 at 04:40:37PM +0400, Vladislav Bolkhovitin wrote:
>> Hello,
>>
>> After upgrading to 2.6.31 with SCST testings I started seeing the  
>> following lockdep messages. I have not seen them in 2.6.29. Looks like  
>> it's something recently introduced.
> 
> The lockdep code to track this has been recently introduced.
> 
> I've sent some patches to fix it ages ago, but so far no one has
> bothered to review them.

Christoph, remind me again which patch and I'll try to find time now
that I'm getting Fedora bug reports.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
