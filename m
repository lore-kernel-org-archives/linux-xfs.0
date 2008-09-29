Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 01:30:50 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8T8Ujd1022815
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 01:30:45 -0700
Message-ID: <48E094BA.8060009@sgi.com>
Date: Mon, 29 Sep 2008 18:41:30 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: compiler warning after applying btree patches
References: <48E084D5.30205@sgi.com> <20080929073033.GA30795@infradead.org>
In-Reply-To: <20080929073033.GA30795@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Mon, Sep 29, 2008 at 05:33:41PM +1000, Lachlan McIlroy wrote:
>> Christoph,
>>
>> After applying the first round of btree patches we've now got this warning
>> when building a non-debug xfs module.
>>
>>  CC      fs/xfs/xfs_btree.o
>> fs/xfs/xfs_btree.c:191: warning: ?xfs_btree_check_ptr? defined but not used
>>
>> I took a quick look through your next round of btree patches but couldn't
>> see a fix for it.  Did I miss something in the original patch set?  Is it
>> fixed in a later patch?  If not here's a fix:
> 
> No, it's not used for now.  For some reason I missed the warning.
> 
> The patch looks good, can you also put it into xfs-cmds so the two
> copies stay in sync?

Okay.  Thanks.
