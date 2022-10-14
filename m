Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7F1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 03:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJNDiG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 23:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiJNDiF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 23:38:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B18192992
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 20:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665718682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6rkr0aaABnoiYxLWq+VX2rUhGkAk75ISZ4B7+swiU84=;
        b=Sj0kHgkU+pYBfzb5/c50KYMbHdVaNKzMg9G95Czow5B35MA29dj6FSSSc7DbwpjvPYWiNn
        Axix5/MCok5qy3j1mebPU82bxN9beHuUulL6EKJ0m18ybwyTMT4hqZXh7Tb8zFoz2VMm6e
        1gTN0qrFeZG+60Z9xjp9rsvpPoWux40=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-318-CmRkqrj7M6GfDcm34wVLIw-1; Thu, 13 Oct 2022 23:38:00 -0400
X-MC-Unique: CmRkqrj7M6GfDcm34wVLIw-1
Received: by mail-pg1-f197.google.com with SMTP id r126-20020a632b84000000b004393806c06eso1988521pgr.4
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 20:38:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6rkr0aaABnoiYxLWq+VX2rUhGkAk75ISZ4B7+swiU84=;
        b=x4GSBJDAoheKI6gGPbQT//M/XMUk1xMSKN+TjNDSsrCuBeHNrDs71XFkEk7XHER3VX
         511oR+vrQdrwpIOiXyBQo7Grzw678sco4LDV3EMKGOOcuLLPzcZEQ/lUPfKArGAkYbu6
         yF9G3p+2w1ZbE9JC1yVMwYKnj9viTLOTibzw+KdkmusBdEB6pKu09idhKiITFGzlao5Z
         T+zkknWlXaFTZRuZrMUXxZ4HWV11f2Y3IzwKmakkDtxbWKW2qLUMo+SqOWdt4l62zGlz
         wtafBQPyDmPxd8aN1Y+I6cuMY7yLff1aH6h0m9aRUGGV9ip0Zj8+YlhsXFrnEpULj+N2
         bFQA==
X-Gm-Message-State: ACrzQf1ldk3edj+H55yKjrEyVjzE8Rndb5ZaQvKTzg5BDO26CP5NRO1p
        5aIKk2AfP806/4oBueNSC6rG65Kd/fUGiZO29oA2VakvyAzCncMIi9J/GrH0GrrbnSUcwIfANAi
        vUPOv4b5JeJ9OITAEtMqq
X-Received: by 2002:a63:d314:0:b0:452:598a:cc5a with SMTP id b20-20020a63d314000000b00452598acc5amr2827047pgg.299.1665718679282;
        Thu, 13 Oct 2022 20:37:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6gIRwwxVhzgljgP+MmlnG0Z2rsufT1eChL0JsaMWqroi5K4hZtiGxH06v0xEo/nEzuzYWwdg==
X-Received: by 2002:a63:d314:0:b0:452:598a:cc5a with SMTP id b20-20020a63d314000000b00452598acc5amr2827026pgg.299.1665718678844;
        Thu, 13 Oct 2022 20:37:58 -0700 (PDT)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id u7-20020a170903124700b0017a1145eec7sm562475plh.157.2022.10.13.20.37.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 20:37:58 -0700 (PDT)
Message-ID: <b13322f2-9157-d3ff-d571-26bf75af9700@redhat.com>
Date:   Fri, 14 Oct 2022 14:37:54 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/4] xfsrestore: fix on-media inventory stream unpacking
Content-Language: en-AU
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20221013031518.1815861-1-ddouwsma@redhat.com>
 <20221013031518.1815861-3-ddouwsma@redhat.com> <Y0hhj+FFF4TYA6N6@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <Y0hhj+FFF4TYA6N6@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 14/10/2022 06:05, Darrick J. Wong wrote:
> On Thu, Oct 13, 2022 at 02:15:16PM +1100, Donald Douwsma wrote:
>> xfsdump can create multiple streams, when restoring the online inventory
>> with multiple streams we fail to process these and assert when the
>> inventory buffer is not fully decoded.
>>
>> [root@rhel8 ~]# xfsdump -L "Test1" -f /dev/nst0 -M tape1 -f /dev/nst1 -M tape2 /boot
>> xfsdump: using scsi tape (drive_scsitape) strategy
>> xfsdump: using scsi tape (drive_scsitape) strategy
>> xfsdump: version 3.1.8 (dump format 3.0) - type ^C for status and control
>> xfsdump: level 0 dump of rhel8:/boot
>> xfsdump: dump date: Thu Oct  6 13:50:45 2022
>> xfsdump: session id: aa25fa48-4493-45c7-9027-61e53e486445
>> xfsdump: session label: "Test1"
>> xfsdump: ino map phase 1: constructing initial dump list
>> xfsdump: ino map phase 2: skipping (no pruning necessary)
>> xfsdump: ino map phase 3: identifying stream starting points
>> xfsdump: stream 0: ino 133 offset 0 to ino 28839 offset 0
>> xfsdump: stream 1: ino 28839 offset 0 to end
>> xfsdump: ino map construction complete
>> xfsdump: estimated dump size: 328720704 bytes
>> xfsdump: estimated dump size per stream: 164375728 bytes
>> xfsdump: /var/lib/xfsdump/inventory created
>> xfsdump: drive 0: preparing drive
>> xfsdump: drive 1: preparing drive
>> xfsdump: drive 1: creating dump session media file 0 (media 0, file 0)
>> xfsdump: drive 1: dumping ino map
>> xfsdump: drive 1: dumping non-directory files
>> xfsdump: drive 0: creating dump session media file 0 (media 0, file 0)
>> xfsdump: drive 0: dumping ino map
>> xfsdump: drive 0: dumping directories
>> xfsdump: drive 0: dumping non-directory files
>> xfsdump: drive 1: ending media file
>> xfsdump: drive 1: media file size 166723584 bytes
>> xfsdump: drive 1: waiting for synchronized session inventory dump
>> xfsdump: drive 0: ending media file
>> xfsdump: drive 0: media file size 165675008 bytes
>> xfsdump: drive 0: waiting for synchronized session inventory dump
>> xfsdump: drive 0: dumping session inventory
>> xfsdump: drive 0: beginning inventory media file
>> xfsdump: drive 0: media file 1 (media 0, file 1)
>> xfsdump: drive 0: ending inventory media file
>> xfsdump: drive 0: inventory media file size 2097152 bytes
>> xfsdump: drive 0: writing stream terminator
>> xfsdump: drive 0: beginning media stream terminator
>> xfsdump: drive 0: media file 2 (media 0, file 2)
>> xfsdump: drive 0: ending media stream terminator
>> xfsdump: drive 0: media stream terminator size 1048576 bytes
>> xfsdump: drive 1: dumping session inventory
>> xfsdump: drive 1: beginning inventory media file
>> xfsdump: drive 1: media file 1 (media 0, file 1)
>> xfsdump: drive 1: ending inventory media file
>> xfsdump: drive 1: inventory media file size 2097152 bytes
>> xfsdump: drive 1: writing stream terminator
>> xfsdump: drive 1: beginning media stream terminator
>> xfsdump: drive 1: media file 2 (media 0, file 2)
>> xfsdump: drive 1: ending media stream terminator
>> xfsdump: drive 1: media stream terminator size 1048576 bytes
>> xfsdump: dump size (non-dir files) : 328189016 bytes
>> xfsdump: dump complete: 4 seconds elapsed
>> xfsdump: Dump Summary:
>> xfsdump:   stream 0 /dev/nst0 OK (success)
>> xfsdump:   stream 1 /dev/nst1 OK (success)
>> xfsdump: Dump Status: SUCCESS
>> [root@rhel8 ~]# xfsdump -I
>> file system 0:
>> 	fs id:		26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>> 	session 0:
>> 		mount point:	rhel8:/boot
>> 		device:		rhel8:/dev/sda1
>> 		time:		Thu Oct  6 13:50:45 2022
>> 		session label:	"Test1"
>> 		session id:	aa25fa48-4493-45c7-9027-61e53e486445
>> 		level:		0
>> 		resumed:	NO
>> 		subtree:	NO
>> 		streams:	2
>> 		stream 0:
>> 			pathname:	/dev/nst0
>> 			start:		ino 133 offset 0
>> 			end:		ino 28839 offset 0
>> 			interrupted:	NO
>> 			media files:	2
>> 			media file 0:
>> 				mfile index:	0
>> 				mfile type:	data
>> 				mfile size:	165675008
>> 				mfile start:	ino 133 offset 0
>> 				mfile end:	ino 28839 offset 0
>> 				media label:	"tape1"
>> 				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
>> 			media file 1:
>> 				mfile index:	1
>> 				mfile type:	inventory
>> 				mfile size:	2097152
>> 				media label:	"tape1"
>> 				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
>> 		stream 1:
>> 			pathname:	/dev/nst1
>> 			start:		ino 28839 offset 0
>> 			end:		ino 1572997 offset 0
>> 			interrupted:	NO
>> 			media files:	2
>> 			media file 0:
>> 				mfile index:	0
>> 				mfile type:	data
>> 				mfile size:	166723584
>> 				mfile start:	ino 28839 offset 0
>> 				mfile end:	ino 1572997 offset 0
>> 				media label:	"tape2"
>> 				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
>> 			media file 1:
>> 				mfile index:	1
>> 				mfile type:	inventory
>> 				mfile size:	2097152
>> 				media label:	"tape2"
>> 				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
>> xfsdump: Dump Status: SUCCESS
>> [root@rhel8 ~]# mv /var/lib/xfsdump/inventory /var/lib/xfsdump/inventory_two_sessions
>> [root@rhel8 ~]# xfsdump -I
>> xfsdump: Dump Status: SUCCESS
>>
>> [root@rhel8 ~]# xfsrestore -L Test1 -f /dev/nst0 /tmp/test1/
>> xfsrestore: using scsi tape (drive_scsitape) strategy
>> xfsrestore: version 3.1.8 (dump format 3.0) - type ^C for status and control
>> xfsrestore: searching media for dump
>> xfsrestore: preparing drive
>> xfsrestore: examining media file 2
>> xfsrestore: found dump matching specified label:
>> xfsrestore: hostname: rhel8
>> xfsrestore: mount point: /boot
>> xfsrestore: volume: /dev/sda1
>> xfsrestore: session time: Thu Oct  6 13:50:45 2022
>> xfsrestore: level: 0
>> xfsrestore: session label: "Test1"
>> xfsrestore: media label: "tape1"
>> xfsrestore: file system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>> xfsrestore: session id: aa25fa48-4493-45c7-9027-61e53e486445
>> xfsrestore: media id: adb31f2a-f026-4597-a20a-326f28ecbaf1
>> xfsrestore: searching media for directory dump
>> xfsrestore: rewinding
>> xfsrestore: examining media file 0
>> xfsrestore: reading directories
>> xfsrestore: 9 directories and 320 entries processed
>> xfsrestore: directory post-processing
>> xfsrestore: restoring non-directory files
>> xfsrestore: examining media file 1
>> xfsrestore: inv_stobj.c:1119: stobj_unpack_sessinfo: Assertion `(size_t) ( p - (char *) bufp ) == bufsz' failed.
>> Aborted (core dumped)
>>
>> Make sure we unpack multiple streams when restoring the online
>> inventory from media.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> 
> Much better now, though I hope there's an fstest coming to make sure
> that multistream restore/dump work properly.

That could be a little tricky.

xfstests currently only supports one TAPE_DEV (and a remote
RMT_TAPE_DEV). So we'd need to add support for multiple tapes,
something like

TAPE_DEV1=/dev/nst0
TAPE_DEV2=/dev/nst1

Then it can be hard to get access to a tape drive, let alone two.

Probably the easiest way to address that is to provide instructions on
how to setup mhvtl, https://github.com/markh794/mhvtl and load the
tapes before a test run with

[root@rhel8 ~]# systemctl start mhvtl.target
[root@rhel8 ~]# mtx -f /dev/sch0 load 1 0; mtx -f /dev/sch load 2 1
Loading media from Storage Element 1 into drive 0...done
Loading media from Storage Element 2 into drive 1...done
[root@rhel8 ~]# ./check -g xfs/tape

Not sure there's many people who test the tape group, so this may be
generally useful.

mhvtl requires a kernel module to be built, not sure if that would
bother QE folk when doing general tests, but for xfsdump userspace
testing it should be fine.

Don


> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>> ---
>>   inventory/inv_stobj.c | 13 +++++++------
>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
>> index b461666..025d431 100644
>> --- a/inventory/inv_stobj.c
>> +++ b/inventory/inv_stobj.c
>> @@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
>>   		return BOOL_FALSE;
>>   	}
>>   
>> +	/* get the seshdr and then, the remainder of the session */
>>   	xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
>>   	bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
>> -
>> -	/* get the seshdr and then, the remainder of the session */
>>   	s->seshdr = (invt_seshdr_t *)p;
>>   	s->seshdr->sh_sess_off = -1;
>>   	p += sizeof(invt_seshdr_t);
>>   
>> -
>>   	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
>>   	bcopy (tmpbuf, p, sizeof(invt_session_t));
>>   	s->ses = (invt_session_t *)p;
>>   	p += sizeof(invt_session_t);
>>   
>>   	/* the array of all the streams belonging to this session */
>> -	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
>> -	bcopy(tmpbuf, p, sizeof(invt_stream_t));
>>   	s->strms = (invt_stream_t *)p;
>> -	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
>> +	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
>> +		xlate_invt_stream((invt_stream_t *)p,
>> +				  (invt_stream_t *)tmpbuf, 1);
>> +		bcopy(tmpbuf, p, sizeof(invt_stream_t));
>> +		p += sizeof(invt_stream_t);
>> +	}
>>   
>>   	/* all the media files */
>>   	s->mfiles = (invt_mediafile_t *)p;
>> -- 
>> 2.31.1
>>
> 

