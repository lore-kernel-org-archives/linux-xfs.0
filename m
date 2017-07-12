Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55612 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbdGLTdj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Jul 2017 15:33:39 -0400
Received: from [10.0.0.114] (provider [10.0.0.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 627957FC379
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2017 14:33:10 -0500 (CDT)
Subject: Re: [PATCH] xfsdump: fix race condition between lseek() and
 read()/write()
From: Eric Sandeen <sandeen@sandeen.net>
References: <1461244016-7373-1-git-send-email-eguan@redhat.com>
 <9253902d-060e-77d7-84af-b5faa1a43e92@sandeen.net>
Message-ID: <808bf487-7106-d277-99fa-098d4001c005@sandeen.net>
Date: Wed, 12 Jul 2017 14:33:28 -0500
MIME-Version: 1.0
In-Reply-To: <9253902d-060e-77d7-84af-b5faa1a43e92@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>


On 07/12/2017 01:46 PM, Eric Sandeen wrote:
> 
> 

Sorry, I was wrong ...


>> diff --git a/inventory/inv_idx.c b/inventory/inv_idx.c
>> index 95529e8..cd9b9cb 100644
>> --- a/inventory/inv_idx.c
>> +++ b/inventory/inv_idx.c
>> @@ -341,8 +341,8 @@ idx_put_sesstime( inv_sestoken_t tok, bool_t whichtime)
> 
>         rval = GET_REC_NOLOCK( fd, &ent, sizeof( invt_entry_t ),
>                                 tok->sd_invtok->d_invindex_off);
> 
> This sets the offset to d_invindex_off

... and reads sizeof(invt_entry_t), advancing by that much.

>>  			      ent.ie_timeperiod.tp_start,
>>  			      ent.ie_timeperiod.tp_end );
>>  #endif
>> -	rval = PUT_REC_NOLOCK_SEEKCUR( fd, &ent, sizeof( invt_entry_t ),
>> -				      -(off64_t)(sizeof( invt_entry_t )));
> 
> This backed up one entry from the current offset...
which goes back to...

> 
>> +	rval = PUT_REC_NOLOCK(fd, &ent, sizeof(invt_entry_t),
>> +			      tok->sd_invtok->d_invindex_off);

...d_invindex_off.  Sorry for the false alarm.

-eric

> 
> but this keeps it at the current offset, no?  Isn't this a different behavior?
> 
>
