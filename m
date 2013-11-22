Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3103C7F50
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 09:34:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1BBA58F8064
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 07:34:38 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CCofJkhjDCQ3KfXO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Nov 2013 07:34:37 -0800 (PST)
Message-ID: <528F796F.6070601@oracle.com>
Date: Fri, 22 Nov 2013 23:34:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix assertion failure at xfs_setattr_nonsize
References: <528F743D.9010800@oracle.com> <20131122151735.GA2405@infradead.org>
In-Reply-To: <20131122151735.GA2405@infradead.org>
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

On 11/22 2013  23:17 PM, Christoph Hellwig wrote:
> On Fri, Nov 22, 2013 at 11:11:57PM +0800, Jeff Liu wrote:
>> To remain the current semantics under the debug mode, this fix add
>> an additional judgement to make this assertion only works for non-CRC
>> enabled version.
> 
>>  		if (!gid_eq(igid, gid)) {
>>  			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
>> -				ASSERT(!XFS_IS_PQUOTA_ON(mp));
>> +#ifdef DEBUG quota
>> +				if (!xfs_sb_version_has_pquotino(&mp->m_sb))
>> +					ASSERT(!XFS_IS_PQUOTA_ON(mp));
>> +#endif
>>  				ASSERT(mask & ATTR_GID);
>>  				ASSERT(gdqp);
> 
> I'd just kill this assert.
I hesitated about killing this assertion or hold the line before, will fix it soon.
> And it would be good to get some coverage
> of running with all three quotas types into xfstests by default..
Definitely!  I just found another race problem between dquot attach and quota off via
fsstress as per Dave's suggestion for another fix. :)

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
