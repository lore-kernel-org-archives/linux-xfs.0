Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCD2C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 23:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiI1XCt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 19:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiI1XCr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 19:02:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA743AE71
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 16:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664406165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y2NSAk2nnr1eVHHAawfGoaiuT8DC4Vy0kkc4foFFC5I=;
        b=gjZcoFeQzAIHYAI3MaF6U0jDd4bYjcNNfew72SmQZamzTtNsixsZ5Eq8f8c2TcMPFyYxrN
        YR2pgrRaSqLw1NNfUC24o2t69q8uIQt+keqCNhrD5jw2xEwGwDSRtfwNeH+powBJeez23S
        YZJ4mptqv/3TVyu/a0IoqCbccfQmY+w=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-497-9ydxNeLOOj-HafetX5t0Qw-1; Wed, 28 Sep 2022 19:02:44 -0400
X-MC-Unique: 9ydxNeLOOj-HafetX5t0Qw-1
Received: by mail-pg1-f198.google.com with SMTP id m188-20020a633fc5000000b00434dccacd4aso8162352pga.10
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 16:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Y2NSAk2nnr1eVHHAawfGoaiuT8DC4Vy0kkc4foFFC5I=;
        b=BQmgVQza7QrIEalOb+B4c733Ch0bF2sakUkGSzRzfKd7nfvW3BCfFX3/E3w2mCyMLv
         EEXfJyH5ATlbFiDSopKD+gHGQ/nKiWhEJWeV4nnVGMsSmR94eEcDtc3cybrV/RKGZrlP
         ckxD9i7mWZilNqmN7Lf96XjJafz7j0ux9Xyx8ustXPvToTNQ2iyubyEI3zybksLzqaD2
         uQ8k4JKWi9Qv9Kn0Ub+cC1s+g/vsL1TMqRzxMVrbWT9mPDbp84mPPaoChTkK33DiojLa
         FbDl8hdn0WPscrZ5qZGoxBWGKRSpgZOBg3rdV0ePuEhLuVHyPSMAB2eChzE81Ri5KTIG
         ppVg==
X-Gm-Message-State: ACrzQf1KvnVRvXBvvSBHu+sU5GSeHuUZ1RPrdu+iETMEH53wN020RkB0
        D5p7HDWBpp9EcBViAdysB3dCGqYcAM8IN7SY7YkeuFRkV7q0iz8IRJqokAFXApyydh0mfSw/d1D
        FtyCznwwdMZX4HxNhH3iM
X-Received: by 2002:a17:902:d588:b0:17a:487:ff99 with SMTP id k8-20020a170902d58800b0017a0487ff99mr342563plh.44.1664406162822;
        Wed, 28 Sep 2022 16:02:42 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6Kiobg3oMWVMo0z/x+q/YNxM56xYLlYMidUxVQ+9VbpXN69JqL0bubFK/VbmmzbEZERXcjuQ==
X-Received: by 2002:a17:902:d588:b0:17a:487:ff99 with SMTP id k8-20020a170902d58800b0017a0487ff99mr342534plh.44.1664406162460;
        Wed, 28 Sep 2022 16:02:42 -0700 (PDT)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090a00c900b00205f5ff3e3bsm365816pjd.10.2022.09.28.16.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 16:02:42 -0700 (PDT)
Message-ID: <a81cc445-713a-282d-6fb4-b3f6f718d9b4@redhat.com>
Date:   Thu, 29 Sep 2022 09:02:37 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/3] xfsrestore: fix inventory unpacking
Content-Language: en-AU
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-2-ddouwsma@redhat.com> <YzRkQ8zxKWPiyGNa@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <YzRkQ8zxKWPiyGNa@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 29/09/2022 01:12, Darrick J. Wong wrote:
> On Wed, Sep 28, 2022 at 03:53:05PM +1000, Donald Douwsma wrote:
>> When xfsrestore reads the inventory from tape media it fails to convert
>> media file records from bigendian. If the xfsdump inventory is not
>> available xfsrestore will write this invalid record to the on-line
>> inventory.
>>
>> [root@rhel8 ~]# xfsdump -L Test1 -M "" -f /dev/st0 /boot > /dev/null
>> [root@rhel8 ~]# xfsdump -L Test2 -M "" -f /dev/st0 /boot > /dev/null
>> [root@rhel8 ~]# rm -rf /var/lib/xfsdump/inventory/
>> [root@rhel8 ~]# mt -f /dev/nst0 asf 2
>> [root@rhel8 ~]# xfsrestore -f /dev/nst0 -L Test2 /tmp/test2
>> xfsrestore: using scsi tape (drive_scsitape) strategy
>> xfsrestore: version 3.1.8 (dump format 3.0) - type ^C for status and control
>> xfsrestore: searching media for dump
>> xfsrestore: preparing drive
>> xfsrestore: examining media file 3
>> xfsrestore: found dump matching specified label:
>> xfsrestore: hostname: rhel8
>> xfsrestore: mount point: /boot
>> xfsrestore: volume: /dev/sda1
>> xfsrestore: session time: Tue Sep 27 16:05:28 2022
>> xfsrestore: level: 0
>> xfsrestore: session label: "Test2"
>> xfsrestore: media label: ""
>> xfsrestore: file system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>> xfsrestore: session id: 62402423-7ae0-49ed-8ecb-9e5bc7642b91
>> xfsrestore: media id: 47ba45ca-3417-4006-ab10-3dc6419b83e2
>> xfsrestore: incorporating on-media session inventory into online inventory
>> xfsrestore: /var/lib/xfsdump/inventory created
>> xfsrestore: using on-media session inventory
>> xfsrestore: searching media for directory dump
>> xfsrestore: rewinding
>> xfsrestore: examining media file 0
>> xfsrestore: inventory session uuid (62402423-7ae0-49ed-8ecb-9e5bc7642b91) does not match the media header's session uuid (1771d9e8-a1ba-4e87-a61e-f6be97e41b45)
>> xfsrestore: examining media file 1
>> xfsrestore: inventory session uuid (62402423-7ae0-49ed-8ecb-9e5bc7642b91) does not match the media header's session uuid (1771d9e8-a1ba-4e87-a61e-f6be97e41b45)
>> xfsrestore: examining media file 2
>> xfsrestore: reading directories
>> xfsrestore: 9 directories and 320 entries processed
>> xfsrestore: directory post-processing
>> xfsrestore: restore complete: 0 seconds elapsed
>> xfsrestore: Restore Summary:
>> xfsrestore:   stream 0 /dev/nst0 OK (success)
>> xfsrestore: Restore Status: SUCCESS
>> [root@rhel8 ~]# xfsdump -I
>> file system 0:
>>          fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>>          session 0:
>>                  mount point:    rhel8:/boot
>>                  device:         rhel8:/dev/sda1
>>                  time:           Tue Sep 27 16:05:28 2022
>>                  session label:  "Test2"
>>                  session id:     62402423-7ae0-49ed-8ecb-9e5bc7642b91
>>                  level:          0
>>                  resumed:        NO
>>                  subtree:        NO
>>                  streams:        1
>>                  stream 0:
>>                          pathname:       /dev/st0
>>                          start:          ino 133 offset 0
>>                          end:            ino 1572997 offset 0
>>                          interrupted:    YES
>>                          media files:    1
>>                          media file 0:
>>                                  mfile index:    33554432
>>                                  mfile type:     data
>>                                  mfile size:     211187836911616
>>                                  mfile start:    ino 9583660007044415488 offset 0
>>                                  mfile end:      ino 9583686395323482112 offset 0
>>                                  media label:    ""
>>                                  media id:       47ba45ca-3417-4006-ab10-3dc6419b83e2
>> xfsdump: Dump Status: SUCCESS
>> [root@rhel8 ~]#
>> [root@rhel8 ~]# ls /tmp/test2
>> efi  grub2  loader
>>
>> The invalid start and end inode information cause xfsrestore to consider
>> that non-directory files do not reside in the current media and will
>> fail to restore them.
>>
>> The behaviour of an initial restore may succeed if the position of the
>> tape is such that the data file is encountered before the inventory
>> file, or if there is only one dump session on tape, xfsrestore is
>> somewhat inconsistent in this regard. Subsequent restores will use the
>> invalid on-line inventory and fail to restore files.
>>
>> Fix this by correctly unpacking the inventory data.
>>
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>>   inventory/inv_stobj.c | 27 +++++++--------------------
>>   1 file changed, 7 insertions(+), 20 deletions(-)
>>
>> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
>> index c20e71c..5075ee4 100644
>> --- a/inventory/inv_stobj.c
>> +++ b/inventory/inv_stobj.c
>> @@ -1008,7 +1008,7 @@ stobj_unpack_sessinfo(
>>           size_t             bufsz,
>>   	invt_sessinfo_t   *s)
>>   {
>> -	uint 		 i;
>> +	uint 		 i, j;
>>   	char	         *tmpbuf;
>>   	char 		 *p = (char *)bufp;
>>   
>> @@ -1087,26 +1087,13 @@ stobj_unpack_sessinfo(
>>   
>>   	/* all the media files */
>>   	s->mfiles = (invt_mediafile_t *)p;
>> -
>> -#ifdef INVT_DELETION
>> -	{
>> -		int tmpfd = open("moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR);
> 
> I wonder, do you need to preserve this behavior (writing the inventory
> records to "moids")?  testmain.c seems to want to read the file, but
> OTOH that looks like some sort of test program; arbitrarily overwriting
> a file in $PWD seems ... risky?  And I guess this chunk has never run.
> 
> Also testmain.c has such gems as:
> 
> "/dana/hates/me"
> 
> "/the/krays"
> 
> and mentions that -I supersedes most of its functionality.  So maybe
> that's why you deleted moids?  Aside from the name just sounding gross?
> 
> :)
> 

I think they were trying to mirror what's done in stobj_pack_sessinfo(),
which takes a file handle as a parameter, possibly its meant to provide
locking while packing for the inventory. Calling put_invtrecord without
having first called get_invtrecord seems unbalanced, and the unneeded
file "mods" was just left around. Either way the target for
stobj_unpack_sessinfo is a buffer not a file.

AFIKT this was a work in progress by someone who never got to finish it.

>> -		uint j;
>> -		invt_mediafile_t *mmf = s->mfiles;
>> -		for (i=0; i< s->ses->s_cur_nstreams; i++) {
>> -			for (j=0; j< s->strms[i].st_nmediafiles;
>> -			     j++, mmf++)
>> -				xlate_invt_mediafile((invt_mediafile_t *)mmf, (invt_mediafile_t *)tmpbuf, 1);
>> -				bcopy(tmpbuf, mmf, sizeof(invt_mediafile_t));
>> -				put_invtrecord(tmpfd, &mmf->mf_moid,
>> -					 sizeof(uuid_t), 0, SEEK_END, 0);
>> +	for (i=0; i< s->ses->s_cur_nstreams; i++) {
>> +		for (j=0; j < s->strms[i].st_nmediafiles; j++) {
>> +			xlate_invt_mediafile((invt_mediafile_t *)p,
> 
> Nit: trailing whitespace                                      here ^

Urg, sorry I thought I'd fixed all the white-space problems.

> 
> If the the answer to the above question is "Yeah, nobody wants the moids
> file" then:

Yes, I think moids was a hack that shouldn't have been there.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>> +					     (invt_mediafile_t *)tmpbuf, 1);
>> +			bcopy(tmpbuf, p, sizeof(invt_mediafile_t));
>> +			p +=  sizeof(invt_mediafile_t);
>>   		}
>> -		close(tmpfd);
>> -	}
>> -#endif
>> -	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
>> -		p += (size_t) (s->strms[i].st_nmediafiles)
>> -			* sizeof(invt_mediafile_t);
>>   	}
>>   
>>   	/* sanity check the size of the buffer given to us vs. the size it
>> -- 
>> 2.31.1
>>
> 

