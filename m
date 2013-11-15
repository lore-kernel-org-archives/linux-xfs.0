Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74F2E7F89
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 09:37:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1241CAC008
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 07:37:29 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SgW5UcKTASBtkDW5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 07:37:28 -0800 (PST)
Message-ID: <52863F99.7050808@oracle.com>
Date: Fri, 15 Nov 2013 23:36:57 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
References: <52849CC5.10109@oracle.com>
	<20131114140916.GA13501@infradead.org>	<52857BEB.4010406@oracle.com>
	<20131115140928.GB17561@infradead.org>
In-Reply-To: <20131115140928.GB17561@infradead.org>
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
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 11/15 2013 22:09, Christoph Hellwig wrote:
> On Fri, Nov 15, 2013 at 09:42:03AM +0800, Jeff Liu wrote:
>> As per a rough tryout while fixing this problem, it seems that most of those
>> functions are just not be invoked since other precheck-ups were failed before
>> calling them.  We have another old fix for stat_f():
> 
> Most or all?  If this is the only case I'm fine with putting your
> patch in a quick fix, even if I'd prefer the version I suggested for
> the long run.
Most.  I'm in the middle of this check because I found another critical
bug in kernel quota management which can cause xfs_quota hang up, it can
100% reproducible but still under investigation.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
