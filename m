Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 22:58:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m845wi9W020486
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 22:58:45 -0700
Date: Thu, 04 Sep 2008 16:02:14 +1000
Subject: Re: REVIEW: Improve caching in libxfs
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.ugv7ekj83jf8g2@pc-bnaujok.melbourne.sgi.com>
 <20080903234758.GA18368@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.ugx0d0i83jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080903234758.GA18368@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, 04 Sep 2008 09:47:58 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

>>  void
>>  cache_node_put(
>> +	struct cache *		cache,
>>  	struct cache_node *	node)
>>  {
>> +	struct cache_mru *	mru;
>> +
>>  	pthread_mutex_lock(&node->cn_mutex);
>>  #ifdef CACHE_DEBUG
>>  	if (node->cn_count < 1) {
>> @@ -368,8 +372,23 @@ cache_node_put(
>>  				__FUNCTION__, node->cn_count, node);
>>  		cache_abort();
>>  	}
>> +	if (!list_empty(&node->cn_mru)) {
>> +		fprintf(stderr, "%s: node put on node (%p) in MRU list\n",
>> +				__FUNCTION__, node);
>> +		cache_abort();
>> +	}
>
> Assert that we don't put a node that's already on the mru list, okay.
> Shouldn't this be ASSERT?

I chose to make this always abort as it can be triggered outside of
libxfs by xfsprogs usage of it (ie. doing a "put" on a buffer that has
already been "put").

So, I thought this needs to always work, debug or non-debug and
halt immediately if it happens.
