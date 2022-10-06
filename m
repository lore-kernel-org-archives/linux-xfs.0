Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71DC5C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Oct 2022 04:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiJFEn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Oct 2022 00:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiJFEn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Oct 2022 00:43:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5546B2E9D0
        for <linux-xfs@vger.kernel.org>; Wed,  5 Oct 2022 21:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665031403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZLXc322bf9aK6Rx5rqwPOQc37cw/muewiCTfh77wBA=;
        b=CgfLDhba1GWZdZcouSQIwZqF3sIqMt75GDBmuVIZSLYW9TSLbRj6Jh6wLVR1cP3dq0j6hP
        VIqSBDoFqg72X7oBbSgka7tZSzRVsmeIxsWl1rAJpDbY3FbzFqgRdQI6VB22b5FJjfzAW+
        mEmZ3iri7X0UizgPmUD6AT3+CT6YFKo=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-387-py0kaPAhNRO-qr6Cwfi5PA-1; Thu, 06 Oct 2022 00:43:22 -0400
X-MC-Unique: py0kaPAhNRO-qr6Cwfi5PA-1
Received: by mail-pg1-f200.google.com with SMTP id 7-20020a630007000000b0045bb8a49ae6so299645pga.9
        for <linux-xfs@vger.kernel.org>; Wed, 05 Oct 2022 21:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=AZLXc322bf9aK6Rx5rqwPOQc37cw/muewiCTfh77wBA=;
        b=1Z/UIPWDJ04TNU08Q2h4Xghc1d1wPk99wZNFwwz4Mmb8Kgpemf/9fL4UnqFkAmDm6W
         A6vYiCKJX5VLZiE+DYoOmE/mQWHmjya2Kz+iiml59DtxCVdvFXzy/fvLl3My8Hh40pOo
         YXIUJWnU2lNsHiUhCTdL00Uru31Qldj52SwYV7YdZSUjp946L6kJ+f3l5xoKKleHJW8x
         yu3RxZLdAR7dFYRYiN6uCO9YNC7y6iz1PfF5yx9MVA4Ptx88tpYbORyTNrwmk37m8VNf
         Hl/bES2fFfdpXqKpCTuRFghacoCYs8v850czqqumUuaf8FIxQ20+g9YYk9IBGsd5V255
         a4MQ==
X-Gm-Message-State: ACrzQf0x8c2hkGmVs1G4rcKcYCGoi+EBQq8SqXCbIWTTgszaofJ3dDs3
        +EL6wGRg2QbKD4lKaOZvK/odcHj1bzIbu4JHdwClpweuXUAMsIKrhcTkPQJuZMRU879mz7+LiOV
        biSOI8mjd0Jt7TkdKEb5n
X-Received: by 2002:a17:903:1109:b0:179:d220:1f55 with SMTP id n9-20020a170903110900b00179d2201f55mr2777276plh.42.1665031400178;
        Wed, 05 Oct 2022 21:43:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM62Jp+Vywn4Ex6py9aGwFUzs2rsgLxpdoBZDOvBFbJYNwwvw8XVXZDoJBGt6ziqAekKMNqSBQ==
X-Received: by 2002:a17:903:1109:b0:179:d220:1f55 with SMTP id n9-20020a170903110900b00179d2201f55mr2777253plh.42.1665031399737;
        Wed, 05 Oct 2022 21:43:19 -0700 (PDT)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id x184-20020a6231c1000000b0053e4baecc14sm11805537pfx.108.2022.10.05.21.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 21:43:19 -0700 (PDT)
Message-ID: <c5789360-35d2-e63c-e885-700b8bb278e8@redhat.com>
Date:   Thu, 6 Oct 2022 15:43:15 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 2/3] xfsrestore: stobj_unpack_sessinfo cleanup
Content-Language: en-AU
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-3-ddouwsma@redhat.com> <YzRm86tcCc2m+YeX@magnolia>
 <244f6cfb-41f1-ceea-2cc5-c44dcaa14515@redhat.com>
 <b3197f6d-a762-26d5-ca67-3a220fe21b9a@redhat.com> <YzXdfA9wqVopEVMV@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <YzXdfA9wqVopEVMV@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 30/09/2022 04:01, Darrick J. Wong wrote:
> On Thu, Sep 29, 2022 at 09:28:24AM +1000, Donald Douwsma wrote:
>>
>>
>> On 29/09/2022 09:12, Donald Douwsma wrote:
>>>
>>>
>>> On 29/09/2022 01:23, Darrick J. Wong wrote:
>>>> On Wed, Sep 28, 2022 at 03:53:06PM +1000, Donald Douwsma wrote:
>>>>> stobj_unpack_sessinfo should be the reverse of stobj_pack_sessinfo, make
>>>>> this clearer with respect to the session header and streams processing.
>>>>>
>>>>> signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>>>>> ---
>>>>>    inventory/inv_stobj.c | 13 +++++++------
>>>>>    1 file changed, 7 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
>>>>> index 5075ee4..521acff 100644
>>>>> --- a/inventory/inv_stobj.c
>>>>> +++ b/inventory/inv_stobj.c
>>>>> @@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
>>>>>            return BOOL_FALSE;
>>>>>        }
>>>>> +    /* get the seshdr and then, the remainder of the session */
>>>>>        xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
>>>>>        bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
>>>>> -
>>>>> -    /* get the seshdr and then, the remainder of the session */
>>>>>        s->seshdr = (invt_seshdr_t *)p;
>>>>>        s->seshdr->sh_sess_off = -1;
>>>>>        p += sizeof(invt_seshdr_t);
>>>>> -
>>>>>        xlate_invt_session((invt_session_t *)p, (invt_session_t
>>>>> *)tmpbuf, 1);
>>>>>        bcopy (tmpbuf, p, sizeof(invt_session_t));
>>>>>        s->ses = (invt_session_t *)p;
>>>>>        p += sizeof(invt_session_t);
>>>>>        /* the array of all the streams belonging to this session */
>>>>> -    xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
>>>>> -    bcopy(tmpbuf, p, sizeof(invt_stream_t));
>>>>>        s->strms = (invt_stream_t *)p;
>>>>> -    p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
>>>>> +    for (i = 0; i < s->ses->s_cur_nstreams; i++) {
>>>>> +        xlate_invt_stream((invt_stream_t *)p,
>>>>
>>>> Nit: trailing whitespace                        here ^
>>>
>>> nod
>>>
>>>>
>>>>> +                  (invt_stream_t *)tmpbuf, 1);
>>>>> +        bcopy(tmpbuf, p, sizeof(invt_stream_t));
>>>>> +        p += sizeof(invt_stream_t);
>>>>
>>>> Ok, so we translate p into tmpbuf, then bcopy tmpbuf back to p.  That
>>>> part makes sense, but I am puzzled by what stobj_pack_sessinfo does:
>>>>
>>>>      for (i = 0; i < ses->s_cur_nstreams; i++) {
>>>>          xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
>>>>          sesbuf += sizeof(invt_stream_t);
>>>>      }
>>>>
>>>> Why isn't that callsite xlate_invt_stream(&strms[i], ...); ?
>>>
>>> Thanks! Yes, that's wrong, like the existing code it only worked/works
>>> because there's only ever one stream. From the manpage "The third level
>>> is media stream (currently only one  stream is supported)". Will fix.
>>
>> Or should I just drop this clean-up? I think what I'm saying is right,
>> but its a clean-up for a feature that cant be used. I doubt anyone is
>> going to add multiple stream support now, whatever that was intended
>> for.
> 
> I don't know.  On the one hand I could see an argument for at least
> being able to restore multiple streams, but then the dump program has
> been screwing that up for years and nobody noticed.  I can't tell from
> the source code what shape the multistream support is in, so I guess you
> have some research to do? <shrug>  I suppose you could see what happens
> if you try to set up multiple streams, but I have no idea ... what that
> means.
> 
> Sorry that's a nonanswer. :(

Actually this helped a lot, I realised that xfsdump takes multiple -f
arguments on the command line to setup the streams. This allowed me to
do some testing.

TLDR Using the current xfsprogs with multiple streams dumps ok (though
the second stream seems to end up with a higher end ino in its
inventory). But restore asserts when restoring the online inventory as
it fails to consume the media records [1].

With this series it restores ok and restores the inventory without
asserting [2].

If I drop this stobj_unpack_sessinfo cleanup patch we crash when
iterating over the media files for the streams[3].

I'll get a v3 series out including the change to stobj_pack_sessinfo()

Don


[1] Testing dump and restore with current xfsdump.

[root@rhel8 ~]# rpm -q xfsdump
xfsdump-3.1.8-2.el8.x86_64
[root@rhel8 ~]# xfsdump -L "Test1" -f /dev/nst0 -M tape1 -f /dev/nst1 -M 
tape2 /boot
xfsdump: using scsi tape (drive_scsitape) strategy
xfsdump: using scsi tape (drive_scsitape) strategy
xfsdump: version 3.1.8 (dump format 3.0) - type ^C for status and control
xfsdump: level 0 dump of rhel8:/boot
xfsdump: dump date: Thu Oct  6 13:50:45 2022
xfsdump: session id: aa25fa48-4493-45c7-9027-61e53e486445
xfsdump: session label: "Test1"
xfsdump: ino map phase 1: constructing initial dump list
xfsdump: ino map phase 2: skipping (no pruning necessary)
xfsdump: ino map phase 3: identifying stream starting points
xfsdump: stream 0: ino 133 offset 0 to ino 28839 offset 0
xfsdump: stream 1: ino 28839 offset 0 to end
xfsdump: ino map construction complete
xfsdump: estimated dump size: 328720704 bytes
xfsdump: estimated dump size per stream: 164375728 bytes
xfsdump: /var/lib/xfsdump/inventory created
xfsdump: drive 0: preparing drive
xfsdump: drive 1: preparing drive
xfsdump: drive 1: creating dump session media file 0 (media 0, file 0)
xfsdump: drive 1: dumping ino map
xfsdump: drive 1: dumping non-directory files
xfsdump: drive 0: creating dump session media file 0 (media 0, file 0)
xfsdump: drive 0: dumping ino map
xfsdump: drive 0: dumping directories
xfsdump: drive 0: dumping non-directory files
xfsdump: drive 1: ending media file
xfsdump: drive 1: media file size 166723584 bytes
xfsdump: drive 1: waiting for synchronized session inventory dump
xfsdump: drive 0: ending media file
xfsdump: drive 0: media file size 165675008 bytes
xfsdump: drive 0: waiting for synchronized session inventory dump
xfsdump: drive 0: dumping session inventory
xfsdump: drive 0: beginning inventory media file
xfsdump: drive 0: media file 1 (media 0, file 1)
xfsdump: drive 0: ending inventory media file
xfsdump: drive 0: inventory media file size 2097152 bytes
xfsdump: drive 0: writing stream terminator
xfsdump: drive 0: beginning media stream terminator
xfsdump: drive 0: media file 2 (media 0, file 2)
xfsdump: drive 0: ending media stream terminator
xfsdump: drive 0: media stream terminator size 1048576 bytes
xfsdump: drive 1: dumping session inventory
xfsdump: drive 1: beginning inventory media file
xfsdump: drive 1: media file 1 (media 0, file 1)
xfsdump: drive 1: ending inventory media file
xfsdump: drive 1: inventory media file size 2097152 bytes
xfsdump: drive 1: writing stream terminator
xfsdump: drive 1: beginning media stream terminator
xfsdump: drive 1: media file 2 (media 0, file 2)
xfsdump: drive 1: ending media stream terminator
xfsdump: drive 1: media stream terminator size 1048576 bytes
xfsdump: dump size (non-dir files) : 328189016 bytes
xfsdump: dump complete: 4 seconds elapsed
xfsdump: Dump Summary:
xfsdump:   stream 0 /dev/nst0 OK (success)
xfsdump:   stream 1 /dev/nst1 OK (success)
xfsdump: Dump Status: SUCCESS
[root@rhel8 ~]# xfsdump -I
file system 0:
	fs id:		26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
	session 0:
		mount point:	rhel8:/boot
		device:		rhel8:/dev/sda1
		time:		Thu Oct  6 13:50:45 2022
		session label:	"Test1"
		session id:	aa25fa48-4493-45c7-9027-61e53e486445
		level:		0
		resumed:	NO
		subtree:	NO
		streams:	2
		stream 0:
			pathname:	/dev/nst0
			start:		ino 133 offset 0
			end:		ino 28839 offset 0
			interrupted:	NO
			media files:	2
			media file 0:
				mfile index:	0
				mfile type:	data
				mfile size:	165675008
				mfile start:	ino 133 offset 0
				mfile end:	ino 28839 offset 0
				media label:	"tape1"
				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
			media file 1:
				mfile index:	1
				mfile type:	inventory
				mfile size:	2097152
				media label:	"tape1"
				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
		stream 1:
			pathname:	/dev/nst1
			start:		ino 28839 offset 0
			end:		ino 1572997 offset 0
			interrupted:	NO
			media files:	2
			media file 0:
				mfile index:	0
				mfile type:	data
				mfile size:	166723584
				mfile start:	ino 28839 offset 0
				mfile end:	ino 1572997 offset 0
				media label:	"tape2"
				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
			media file 1:
				mfile index:	1
				mfile type:	inventory
				mfile size:	2097152
				media label:	"tape2"
				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
xfsdump: Dump Status: SUCCESS
[root@rhel8 ~]# mv /var/lib/xfsdump/inventory 
/var/lib/xfsdump/inventory_two_sessions
[root@rhel8 ~]# xfsdump -I
xfsdump: Dump Status: SUCCESS

[root@rhel8 ~]# xfsrestore -L Test1 -f /dev/nst0 /tmp/test1/
xfsrestore: using scsi tape (drive_scsitape) strategy
xfsrestore: version 3.1.8 (dump format 3.0) - type ^C for status and control
xfsrestore: searching media for dump
xfsrestore: preparing drive
xfsrestore: examining media file 2
xfsrestore: found dump matching specified label:
xfsrestore: hostname: rhel8
xfsrestore: mount point: /boot
xfsrestore: volume: /dev/sda1
xfsrestore: session time: Thu Oct  6 13:50:45 2022
xfsrestore: level: 0
xfsrestore: session label: "Test1"
xfsrestore: media label: "tape1"
xfsrestore: file system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
xfsrestore: session id: aa25fa48-4493-45c7-9027-61e53e486445
xfsrestore: media id: adb31f2a-f026-4597-a20a-326f28ecbaf1
xfsrestore: searching media for directory dump
xfsrestore: rewinding
xfsrestore: examining media file 0
xfsrestore: reading directories
xfsrestore: 9 directories and 320 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
xfsrestore: examining media file 1
xfsrestore: inv_stobj.c:1119: stobj_unpack_sessinfo: Assertion `(size_t) 
( p - (char *) bufp ) == bufsz' failed.
Aborted (core dumped)

1006 stobj_unpack_sessinfo(
...
1112         /* sanity check the size of the buffer given to us vs. the 
size it
1113            should be */
1114         if ((size_t) (p - (char *) bufp) != bufsz) {
1115                 mlog(MLOG_DEBUG | MLOG_INV, "p-bufp %d != bufsz %d 
entsz %d\n",
1116                       (int)(p - (char *) bufp), (int) bufsz,
1117               (int) (sizeof(invt_entry_t)));
1118         }
1119         assert((size_t) (p - (char *) bufp) == bufsz);


[2] Testing with this series

# remove the houskeeping dir
[root@rhel8 xfsdump-dev]# rm -rf /tmp/test1/*

[root@rhel8 xfsdump-dev]# restore/xfsrestore -L Test1 -f /dev/nst0 
/tmp/test1/
restore/xfsrestore: using scsi tape (drive_scsitape) strategy
restore/xfsrestore: version 3.1.10 (dump format 3.0) - type ^C for 
status and control
restore/xfsrestore: searching media for dump
restore/xfsrestore: preparing drive
restore/xfsrestore: examining media file 2
restore/xfsrestore: found dump matching specified label:
restore/xfsrestore: hostname: rhel8
restore/xfsrestore: mount point: /boot
restore/xfsrestore: volume: /dev/sda1
restore/xfsrestore: session time: Thu Oct  6 13:50:45 2022
restore/xfsrestore: level: 0
restore/xfsrestore: session label: "Test1"
restore/xfsrestore: media label: "tape1"
restore/xfsrestore: file system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
restore/xfsrestore: session id: aa25fa48-4493-45c7-9027-61e53e486445
restore/xfsrestore: media id: adb31f2a-f026-4597-a20a-326f28ecbaf1
restore/xfsrestore: searching media for directory dump
restore/xfsrestore: rewinding
restore/xfsrestore: examining media file 0
restore/xfsrestore: reading directories
restore/xfsrestore: 9 directories and 320 entries processed
restore/xfsrestore: directory post-processing
restore/xfsrestore: restoring non-directory files
restore/xfsrestore: examining media file 1
restore/xfsrestore: incorporating on-media session inventory into online 
inventory
restore/xfsrestore: /var/lib/xfsdump/inventory created
restore/xfsrestore: using on-media session inventory

  ============================ change media dialog 
=============================

please change media in drive
1: media change declined (timeout in 3600 sec)
2: display media inventory status
3: list needed media objects
4: media changed (default)
  -> 1
media change aborted

  --------------------------------- end dialog 
---------------------------------

restore/xfsrestore: NOTE: restore interrupted: 21 seconds elapsed: may 
resume later using -R option
restore/xfsrestore: Restore Summary:
restore/xfsrestore:   stream 0 /dev/nst0 QUIT (media is no longer usable)
restore/xfsrestore: Restore Status: QUIT
[root@rhel8 xfsdump-dev]#

[root@rhel8 xfsdump-dev]# xfsdump -I
file system 0:
	fs id:		26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
	session 0:
		mount point:	rhel8:/boot
		device:		rhel8:/dev/sda1
		time:		Thu Oct  6 13:50:45 2022
		session label:	"Test1"
		session id:	aa25fa48-4493-45c7-9027-61e53e486445
		level:		0
		resumed:	NO
		subtree:	NO
		streams:	2
		stream 0:
			pathname:	/dev/nst0
			start:		ino 133 offset 0
			end:		ino 28839 offset 0
			interrupted:	YES
			media files:	1
			media file 0:
				mfile index:	0
				mfile type:	data
				mfile size:	165675008
				mfile start:	ino 133 offset 0
				mfile end:	ino 28839 offset 0
				media label:	"tape1"
				media id:	adb31f2a-f026-4597-a20a-326f28ecbaf1
		stream 1:
			pathname:	/dev/nst0
			start:		ino 133 offset 0
			end:		ino 28839 offset 0
			interrupted:	YES
			media files:	1
			media file 0:
				mfile index:	0
				mfile type:	data
				mfile size:	166723584
				mfile start:	ino 28839 offset 0
				mfile end:	ino 1572997 offset 0
				media label:	"tape2"
				media id:	22224f02-b6c7-47d5-ad61-a61ba071c8a8
xfsdump: Dump Status: SUCCESS
[root@rhel8 xfsdump-dev]#

[root@rhel8 xfsdump-dev]# mkdir /tmp/test1_
[root@rhel8 xfsdump-dev]# restore/xfsrestore -L Test1 -f /dev/nst0 -f 
/dev/nst1 /tmp/test1_
restore/xfsrestore: using scsi tape (drive_scsitape) strategy
restore/xfsrestore: using scsi tape (drive_scsitape) strategy
restore/xfsrestore: version 3.1.10 (dump format 3.0) - type ^C for 
status and control
restore/xfsrestore: drive 0: using online session inventory
restore/xfsrestore: drive 0: searching media for directory dump
restore/xfsrestore: drive 0: preparing drive
restore/xfsrestore: drive 0: examining media file 2
restore/xfsrestore: drive 0: rewinding
restore/xfsrestore: drive 0: examining media file 0
restore/xfsrestore: drive 0: reading directories
restore/xfsrestore: drive 0: 9 directories and 320 entries processed
restore/xfsrestore: drive 0: directory post-processing
restore/xfsrestore: drive 0: restoring non-directory files
restore/xfsrestore: drive 0: examining media file 1
restore/xfsrestore: drive 0: NOTE: please change media: type ^C to 
confirm media change
restore/xfsrestore: drive 1: preparing drive
restore/xfsrestore: drive 1: examining media file 2
restore/xfsrestore: drive 1: rewinding
restore/xfsrestore: drive 1: examining media file 0
restore/xfsrestore: drive 1: seeking past media file directory dump
restore/xfsrestore: drive 1: restoring non-directory files
restore/xfsrestore: drive 1: examining media file 1
restore/xfsrestore: restore complete: 3 seconds elapsed
restore/xfsrestore: Restore Summary:
restore/xfsrestore:   stream 0 /dev/nst0 ALREADY_DONE (another stream 
completed the operation)
restore/xfsrestore:   stream 1 /dev/nst1 OK (success)
restore/xfsrestore: Restore Status: SUCCESS
[root@rhel8 xfsdump-dev]# xfsdump -I


[3] Removing this stobj_unpack_sessinfo cleanup Segfaults.


[root@rhel8 xfsdump-dev]# gdb restore/xfsrestore
Reading symbols from restore/xfsrestore...done.
(gdb) run -L Test1 -f /dev/nst0 -f /dev/nst1 /tmp/test1
Starting program: 
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore -L Test1 -f 
/dev/nst0 -f /dev/nst1 /tmp/test1
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib64/libthread_db.so.1".
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: using scsi tape 
(drive_scsitape) strategy
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: using scsi tape 
(drive_scsitape) strategy
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: version 3.1.10 
(dump format 3.0) - type ^C for status and control
[New Thread 0x7ffff6b5b700 (LWP 2251)]
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: 
searching media for dump
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: 
preparing drive
[New Thread 0x7ffff635a700 (LWP 2252)]
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 1: 
searching media for dump
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 1: 
preparing drive
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: 
examining media file 1
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: found 
dump matching specified label:
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: 
hostname: rhel8
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: mount 
point: /boot
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: 
volume: /dev/sda1
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: 
session time: Thu Oct  6 13:50:45 2022
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: level: 0
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: 
session label: "Test1"
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: media 
label: "tape1"
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: file 
system id: 26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: 
session id: aa25fa48-4493-45c7-9027-61e53e486445
/root/Devel/upstream/xfs/xfsdump-dev/restore/xfsrestore: drive 0: media 
id: adb31f2a-f026-4597-a20a-326f28ecbaf1

Thread 2 "xfsrestore" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7ffff6b5b700 (LWP 2251)]
0x000000000041fce3 in stobj_unpack_sessinfo (bufp=<optimized out>, 
bufp@entry=0x7ffff7f42010, bufsz=<optimized out>, s=s@entry=0x7ffff6b59880)
     at inv_stobj.c:1094
1094				bcopy(tmpbuf, p, sizeof(invt_mediafile_t));
Missing separate debuginfos, use: yum debuginfo-install 
libuuid-2.32.1-27.el8.x86_64 xfsprogs-5.0.0-8.el8.x86_64
(gdb) bt
#0  0x000000000041fce3 in stobj_unpack_sessinfo (bufp=<optimized out>, 
bufp@entry=0x7ffff7f42010, bufsz=<optimized out>,
     s=s@entry=0x7ffff6b59880) at inv_stobj.c:1094
#1  0x000000000042525b in pi_addfile (mrhdrp=<optimized out>, 
scrhdrp=<optimized out>, drivep=0x65a700, drhdrp=<optimized out>,
     drhdrp=<optimized out>, grhdrp=<optimized out>, Mediap=<optimized 
out>) at content.c:5468
#2  0x000000000042c2ce in content_stream_restore (thrdix=thrdix@entry=0) 
at content.c:2198
#3  0x000000000041614e in childmain (arg1=0x0) at main.c:1465
#4  0x0000000000406daa in cldmgr_entry (arg1=0x652200 <cld>) at cldmgr.c:237
#5  0x00007ffff75a514a in start_thread (arg=<optimized out>) at 
pthread_create.c:479
#6  0x00007ffff72d4dc3 in clone () at 
../sysdeps/unix/sysv/linux/x86_64/clone.S:95
(gdb) list
1089		s->mfiles = (invt_mediafile_t *)p;
1090		for (i=0; i< s->ses->s_cur_nstreams; i++) {
1091			for (j=0; j < s->strms[i].st_nmediafiles; j++) {
1092				xlate_invt_mediafile((invt_mediafile_t *)p,
1093						     (invt_mediafile_t *)tmpbuf, 1);
1094				bcopy(tmpbuf, p, sizeof(invt_mediafile_t));
1095				p +=  sizeof(invt_mediafile_t);
1096			}
1097		}
1098	
(gdb) info locals
i = <optimized out>
j = 832
tmpbuf = 0x7ffff0006f60 ""
p = 0x7ffff7f89f78 ""
__PRETTY_FUNCTION__ = "stobj_unpack_sessinfo"
__x = <optimized out>
__x = <optimized out>
(gdb)

We dont have 832 media files, i think this was setup to fail when didnt
decode the session's st_mediafiles. I steped over this in gdb and
confirmed that it was processing the second session when it did this.

(gdb) p *(s->strms+0)
$6 = {st_startino = {ino = 133, offset = 0}, st_endino = {ino = 28839, 
offset = 0}, st_firstmfile = 5408, st_lastmfile = 5760,
   st_cmdarg = "/dev/nst0", '\000' <repeats 246 times>, st_nmediafiles = 
2, st_interrupted = 1, st_padding = '\000' <repeats 15 times>}

(gdb) p *(s->strms+1)
$7 = {st_startino = {ino = 9583660007044415488, offset = 0}, st_endino = 
{ino = 12065143401725558784, offset = 0},
   st_firstmfile = 2311753983724617728, st_lastmfile = 
-9217179587367141376, st_cmdarg = "/dev/nst0", '\000' <repeats 246 times>,
   st_nmediafiles = 33554432, st_interrupted = 16777216, st_padding = 
'\000' <repeats 15 times>}
(gdb)

$ printf "0x%x\n" 33554432
0x2000000

As Darrick pointed out the second stream is a duplicate of the first
stream since stobj_pack_sessinfo just used the first stream for both
calls in the loop as confirmed by the duplicate st_cmdarg = "/dev/nst0.


> 
> --D
> 
>>
>>>
>>>>
>>>> --D
>>>>
>>>>> +    }
>>>>>        /* all the media files */
>>>>>        s->mfiles = (invt_mediafile_t *)p;
>>>>> -- 
>>>>> 2.31.1
>>>>>
>>>>
>>
> 

