Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o35CRt90248221 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 07:27:55 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD4E4AC00D
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 05:29:41 -0700 (PDT)
Message-ID: <4BB9D7B5.9030805@sgi.com>
Date: Mon, 05 Apr 2010 07:29:41 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsdump: exempt quota files from filesize checks
References: <20100401203956.GA28295@sgi.com>
	<20100403092258.GA20166@infradead.org>
In-Reply-To: <20100403092258.GA20166@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 04/03/2010 04:22 AM, Christoph Hellwig wrote:
> On Thu, Apr 01, 2010 at 03:39:56PM -0500, Bill Kendall wrote:
>> xfsdump backs up quota information by generating quota dump files
>> ("xfs_quota -c dump") in the root of the filesystem being dumped.  If the
>> user filters files from the dump based on max file size (-z option) the
>> quota files may not be dumped. The following patch makes the quota files
>> exempt from the max filesize checks.
>>
>> Signed-off-by: Bill Kendall <wkendall@sgi.com>
>>
>> diff --git a/common/content.h b/common/content.h
>> index e21f38e..03b72f0 100644
>> --- a/common/content.h
>> +++ b/common/content.h
>> @@ -65,6 +65,8 @@ typedef struct content_hdr content_hdr_t;
>>  #define CONTENT_PQUOTAFILE	"xfsdump_quotas_proj"
>>  #define CONTENT_GQUOTAFILE	"xfsdump_quotas_group"
>>  
>> +#ifdef DUMP
> 
> How is this related to the rest of the patch?

is_quota_file() is not defined for xfsrestore. I then noticed
that quota_info_t is not used in xfsrestore, so I expanded the
ifdef to exclude it as well.

> 
>>  /* save quota information in dump
>>   */
>>  static quota_info_t quotas[] = {
>> -	{ "user quota",		BOOL_TRUE,	CONTENT_QUOTAFILE,	"", "-uf", XFS_QUOTA_UDQ_ACCT },
>> -	{ "project quota",	BOOL_TRUE,	CONTENT_PQUOTAFILE,	"", "-pf", XFS_QUOTA_PDQ_ACCT },
>> -	{ "group quota",	BOOL_TRUE,	CONTENT_GQUOTAFILE,	"", "-gf", XFS_QUOTA_GDQ_ACCT }
>> +	{ "user quota",		BOOL_TRUE,	CONTENT_QUOTAFILE,	"", "-uf", XFS_QUOTA_UDQ_ACCT, 0 },
>> +	{ "project quota",	BOOL_TRUE,	CONTENT_PQUOTAFILE,	"", "-pf", XFS_QUOTA_PDQ_ACCT, 0 },
>> +	{ "group quota",	BOOL_TRUE,	CONTENT_GQUOTAFILE,	"", "-gf", XFS_QUOTA_GDQ_ACCT, 0 }
>>  };
> 
> trailing fields in static structures are implicitly filled with zeroes.

I guess I'm accustomed to seeing missing-initializer warnings. Guess
they're not turned on for xfsdump. Better to be explicit anyway, IMHO.

Thanks for the review.

Bill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
