Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BA1B7F88
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 09:03:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 845208F8039
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 07:03:30 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id V8hPeomQZzeFKWZ1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 07:03:29 -0700 (PDT)
Message-ID: <53C7D786.1050509@oracle.com>
Date: Thu, 17 Jul 2014 22:02:46 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs/007: add project quota Q_XQUOTRM test
References: <53C73562.3010005@oracle.com>
	<20140717090714.GA16015@infradead.org>
In-Reply-To: <20140717090714.GA16015@infradead.org>
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
Cc: fstests@vger.kernel.org, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 07/17/2014 17:07 PM, Christoph Hellwig wrote:
> On Thu, Jul 17, 2014 at 10:30:58AM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Add test for project quota Q_XQUOTRM operations, this patch also
>> update the golden output file to match the new output.
> 
> Changing the test to require crc filesystems seems like a bad idea.
> 
> I'd suggest to simply do two passes instead: the first one unchanged,
> and the second one testing project instead of group quotas.

Sounds reasonable to me, will post an updated version soon.

Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
