Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83060C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 01:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJNBQI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 21:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiJNBQF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 21:16:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8753415B329
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 18:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665710150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FYcChuJXR4ztwz3WD5Q5dh5SWut1GfnQJeoaSqsTcRA=;
        b=LR9jpCeI2kb54r9JpYcOK7WYRa9VLASx7VQUrka5B8mai1cC0WSYqJnk0af6hpTff/gJAU
        OeGRyYDDuPphfwy6fNTJMI22sQlFVBFnfbsT4eExSPVWk+2PVvJ//z39ptlRuLAF+SnA5y
        VDtnqzLmZTdDWL+wL29bnpA91/LVFHI=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-443-cHD_azgUPB-D06556o4CYg-1; Thu, 13 Oct 2022 21:15:49 -0400
X-MC-Unique: cHD_azgUPB-D06556o4CYg-1
Received: by mail-pj1-f70.google.com with SMTP id pq17-20020a17090b3d9100b0020a4c65c3a9so1840443pjb.0
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 18:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FYcChuJXR4ztwz3WD5Q5dh5SWut1GfnQJeoaSqsTcRA=;
        b=wr7pz/1qUtoCwndLClZhl04pf9kkeHOJZyR2PGz0GfmYkgthqD5z2Jd5haz4ok8lTv
         MTFTcJDkMjGO29F2qPDx/+jEc8n185pnFEFyfWdu/l/vEQPcNt9E0z3EPOPep5ahm7Wd
         QeXeQ391ccVaiSiOUViRo3njIrx7EW5chVw9Nui4AEt4nzJG25cUC1iYWRXuL3sqNwRf
         Kkf1IJQqhKfUjHkcy3orIG8GhdkF2oLy2cWzs142DLSGai2rND7fxrJ/ooD1KAV1v6DS
         Hn5SLWyfaHn40f5BiAbE2QrshgEzhUM/uXRdLwrw63vj94op9MKDdub2naZSBI+ROPwP
         RR5Q==
X-Gm-Message-State: ACrzQf1Y2e2Ab3jSVswoR71vXpnL18JBVehAYhxzk+5pq2Cb4p5w0vAO
        nWKKXWX0GU4Diu5/NwdgCeHkVrxrRSwJqUbGXx47Omv1tAeMWc65YkO3IwYWnU2j3Xa7WKl85vw
        bXoDlkQscuOrOim8BeIX9
X-Received: by 2002:a65:56ca:0:b0:439:169f:f027 with SMTP id w10-20020a6556ca000000b00439169ff027mr2292468pgs.580.1665710148275;
        Thu, 13 Oct 2022 18:15:48 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6yoOOAmgNhZE4pUE3eS5/a+f4TqKi9XXVJRYaatpHDtRsxHtWtrU2suYRrkArTItF6VcM4RA==
X-Received: by 2002:a65:56ca:0:b0:439:169f:f027 with SMTP id w10-20020a6556ca000000b00439169ff027mr2292454pgs.580.1665710147967;
        Thu, 13 Oct 2022 18:15:47 -0700 (PDT)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id h22-20020aa796d6000000b00561b455267fsm337033pfq.27.2022.10.13.18.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 18:15:47 -0700 (PDT)
Message-ID: <5eb42447-42ba-928c-cf7b-0d50708673be@redhat.com>
Date:   Fri, 14 Oct 2022 12:15:43 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 3/4] xfsdump: fix on-media inventory stream packing
Content-Language: en-AU
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20221013031518.1815861-1-ddouwsma@redhat.com>
 <20221013031518.1815861-4-ddouwsma@redhat.com> <Y0hip0cjfi1oWn1B@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <Y0hip0cjfi1oWn1B@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 14/10/2022 06:10, Darrick J. Wong wrote:
> On Thu, Oct 13, 2022 at 02:15:17PM +1100, Donald Douwsma wrote:
>> With the on-media inventory now being restored for multiple streams we
>> can see that the restored streams both claim to be for /dev/nst0.
>>
>> [root@rhel8 xfsdump-dev]# xfsdump -L "Test2" -f /dev/nst0 -M "tape1" -f /dev/nst1 -M "tape2" /boot
>> ...
>> [root@rhel8 xfsdump-dev]# rm -rf /var/lib/xfsdump/inventory /tmp/test1/*
>> [root@rhel8 xfsdump-dev]# restore/xfsrestore -L Test2 -f /dev/nst0 -f /dev/nst1 /tmp/test2
>> restore/xfsrestore: using scsi tape (drive_scsitape) strategy
>> restore/xfsrestore: using scsi tape (drive_scsitape) strategy
>> restore/xfsrestore: version 3.1.10 (dump format 3.0) - type ^C for status and control
>> ...
>> restore/xfsrestore: Restore Summary:
>> restore/xfsrestore:   stream 0 /dev/nst0 OK (success)
>> restore/xfsrestore:   stream 1 /dev/nst1 ALREADY_DONE (another stream completed the operation)
>> restore/xfsrestore: Restore Status: SUCCESS
>> [root@rhel8 xfsdump-dev]# xfsdump -I
>> file system 0:
>>          fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>>          session 0:
>>                  mount point:    rhel8:/boot
>>                  device:         rhel8:/dev/sda1
>>                  time:           Wed Oct 12 15:36:55 2022
>>                  session label:  "Test2"
>>                  session id:     50be3b17-d9f9-414d-885b-ababf660e189
>>                  level:          0
>>                  resumed:        NO
>>                  subtree:        NO
>>                  streams:        2
>>                  stream 0:
>>                          pathname:       /dev/nst0
>>                          start:          ino 133 offset 0
>>                          end:            ino 28839 offset 0
>>                          interrupted:    YES
>>                          media files:    1
>>                          media file 0:
>>                                  mfile index:    2
>>                                  mfile type:     data
>>                                  mfile size:     165675008
>>                                  mfile start:    ino 133 offset 0
>>                                  mfile end:      ino 28839 offset 0
>>                                  media label:    "test"
> 
> It's odd that you have -M tape1 above but this ends up labelled "test"?
> If that isn't just a munged patch message, then that might need fixing
> (separate patch) as well.

I looked back over the terminals where I tested this and they're all
tape1, I think this was an earlier cut n pasta mistake when I prepared
the commit message. Its probably worth fixing the message because not
everyone will want to setup a virtual tape library to look at this.

Thanks for the reviews,
Don

> The code change looks correct though.  Thanks for fixing dump.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>>                                  media id:       e2e6978d-5546-4f1f-8c9e-307168071889
>>                  stream 1:
>>                          pathname:       /dev/nst0
>>                          start:          ino 133 offset 0
>>                          end:            ino 28839 offset 0
>>                          interrupted:    YES
>>                          media files:    1
>>                          media file 0:
>>                                  mfile index:    0
>>                                  mfile type:     data
>>                                  mfile size:     166723584
>>                                  mfile start:    ino 28839 offset 0
>>                                  mfile end:      ino 1572997 offset 0
>>                                  media label:    "tape2"
>>                                  media id:       1ad6d919-7159-42fb-a20f-5a2c4e3e24b1
>> xfsdump: Dump Status: SUCCESS
>> [root@rhel8 xfsdump-dev]#
>>
>> Fix this by indexing the stream being packed for the on-media inventory.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> Suggested-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>   inventory/inv_stobj.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
>> index 025d431..fb4d93a 100644
>> --- a/inventory/inv_stobj.c
>> +++ b/inventory/inv_stobj.c
>> @@ -798,7 +798,7 @@ stobj_pack_sessinfo(int fd, invt_session_t *ses, invt_seshdr_t *hdr,
>>   	sesbuf += sizeof(invt_session_t);
>>   
>>   	for (i = 0; i < ses->s_cur_nstreams; i++) {
>> -		xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
>> +		xlate_invt_stream(&strms[i], (invt_stream_t *)sesbuf, 1);
>>   		sesbuf += sizeof(invt_stream_t);
>>   	}
>>   
>> -- 
>> 2.31.1
>>
> 

