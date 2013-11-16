Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B0D1B7F37
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 20:54:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A00438F8040
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 18:54:44 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id XM8irv7DrX6DAkyt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 18:54:43 -0800 (PST)
Message-ID: <5286DE50.9040601@oracle.com>
Date: Sat, 16 Nov 2013 10:54:08 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
References: <52849CC5.10109@oracle.com>	<20131114140916.GA13501@infradead.org>	<52857BEB.4010406@oracle.com>	<20131115140928.GB17561@infradead.org>
	<52863F99.7050808@oracle.com>
In-Reply-To: <52863F99.7050808@oracle.com>
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

On 11/15 2013 23:36 PM, Jeff Liu wrote:
> On 11/15 2013 22:09, Christoph Hellwig wrote:
>> On Fri, Nov 15, 2013 at 09:42:03AM +0800, Jeff Liu wrote:
>>> As per a rough tryout while fixing this problem, it seems that most of those
>>> functions are just not be invoked since other precheck-ups were failed before
>>> calling them.  We have another old fix for stat_f():
>>
>> Most or all?  If this is the only case I'm fine with putting your
>> patch in a quick fix, even if I'd prefer the version I suggested for
>> the long run.
> Most.  I'm in the middle of this check because I found another critical
> bug in kernel quota management which can cause xfs_quota hang up, it can
> 100% reproducible but still under investigation.
Sorry for the delay!  I can not find more problems.

AFAICS, there are 6 administrator commands dereference fs_path for further
operation, i.e, free, path, limit, quot, state, report.
Except report, state has already been fixed with fs_path precheck-up, the
others are safe as additional precheck-ups failed.

Thanks,
-Jeff


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
