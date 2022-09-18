Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2105DECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Sep 2022 01:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiIRBvC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 17 Sep 2022 21:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiIRBvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Sep 2022 21:51:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28242A252
        for <linux-xfs@vger.kernel.org>; Sat, 17 Sep 2022 18:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663465858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t+0mOdc+X+3IN3go2NhizkJSAMTJ0h//WX1VWfRRenE=;
        b=AyFEPwnrc4012Of3c0cnfqpb2Xfn/DL4xx+EJ/BW5l2yYPQ9ZmFJk9ulcKgknyxNjKJ0zt
        4naF8vuX54VDgPyrONtio1NfRWm0i681WeUfBfDe6l9ejkm8ATR8Et1hdhDODcHG48yNFy
        /XIsfEu+EiM/buHtuQy2hv+Tfn6ltns=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-471-Lw3T214YNUaoYttAo4d2ag-1; Sat, 17 Sep 2022 21:50:57 -0400
X-MC-Unique: Lw3T214YNUaoYttAo4d2ag-1
Received: by mail-pl1-f198.google.com with SMTP id l2-20020a170902f68200b00177ee7e673eso17275516plg.2
        for <linux-xfs@vger.kernel.org>; Sat, 17 Sep 2022 18:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=t+0mOdc+X+3IN3go2NhizkJSAMTJ0h//WX1VWfRRenE=;
        b=1I7Iyif2S/71kzGTbuYuGRIYKll01z0r/8KFFVVxpq0Cg03A1PDoMNDvHKwO86OfR8
         pLfACvUS6041+SArwlTS16HSRTsyiuEV+Gg4KopnFyEjA+etcDlz+ryMPSqPPhbDL5Gr
         /AwWlEm55fWw7vp95uGLJRjibqotgrZ7xqKB3UEd5BNEuJchs/cJwhx9Ww3VaSb1WzCs
         Xu6ym5zgdZ2eBAOSo9l+/D2LyK5lHqjbWIKZ1zSuYVFQqMyHq/upe9yO1/wHiER/1KmO
         Jb4yqoOw1uMuLSooe3gee4n3HjeRm96A3jzywV5zNGY4HDNppLYl8JVmw0RM2+DqpECl
         ouzw==
X-Gm-Message-State: ACrzQf0XQ87esrpQga/EU47EwZHFPYuuO+aVuDfXABwIHZh6VEOrglNl
        XX0RrJXXiXHhQRwtBc81KAZhWIJCzrLk5lWx/HlzTncZ7/7vVgaMUYUHTdDlZ59gihevVX8iYtk
        4+X2swrBLb8qLuyvwK+nH
X-Received: by 2002:a17:902:e891:b0:178:7b6:92db with SMTP id w17-20020a170902e89100b0017807b692dbmr6843015plg.160.1663465855345;
        Sat, 17 Sep 2022 18:50:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Jm7g8MzljNe6gZLbAYGmEdsHYGi5SDLDuu3HfgdOajc5NFU+MmY0MiAj+N7t3SgYf0I4EnA==
X-Received: by 2002:a17:902:e891:b0:178:7b6:92db with SMTP id w17-20020a170902e89100b0017807b692dbmr6843003plg.160.1663465854998;
        Sat, 17 Sep 2022 18:50:54 -0700 (PDT)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id f16-20020aa79d90000000b005403b8f4bacsm16971598pfq.137.2022.09.17.18.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Sep 2022 18:50:54 -0700 (PDT)
Message-ID: <e0ec02ab-cb64-77b4-c262-0b36564f16cd@redhat.com>
Date:   Sun, 18 Sep 2022 11:50:50 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] xfsrestore: fix inventory unpacking
Content-Language: en-AU
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20220914034708.1605288-1-ddouwsma@redhat.com>
 <YyIPwdERzZsaGDO1@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <YyIPwdERzZsaGDO1@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 15/09/2022 03:30, Darrick J. Wong wrote:
> On Wed, Sep 14, 2022 at 01:47:08PM +1000, Donald Douwsma wrote:
>> When xfsrestore reads the inventory from tape media it fails to convert
>> media file records from bigendin. If the xfsdump inventory is not
> 
> bigendian?

oops, will fix.

> 
>> available xfsrestore will write this invalid record to the on-line
>> inventory.
>>
>> [root@rhel8 xfsdump-dev]# xfsdump -I
>> file system 0:
>>          fs id:          26dd5aa0-b901-4cf5-9b68-0c5753cb3ab8
>>          session 0:
>>                  mount point:    rhel8:/boot
>>                  device:         rhel8:/dev/sda1
>>                  time:           Fri Sep  9 14:29:03 2022
>>                  session label:  ""
>>                  session id:     05f11cfe-2301-4000-89f2-2025091da413
>>                  level:          0
>>                  resumed:        NO
>>                  subtree:        NO
>>                  streams:        1
>>                  stream 0:
>>                          pathname:       /dev/nst0
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
>>                                  media id:       4bf9ed40-6377-4926-be62-1bf7b59b1619
>> xfsdump: Dump Status: SUCCESS
>>
>> The invalid start and end inode information cause xfsrestore to consider
> 
> What's invalid here?  I gather it's the transition from 1572997 to
> 9583660007044415488?

Yes, for a single media file the inode information should be the same
as for the stream, for multiple media (big tape files that are split or
or multiple tapes) it should be the range of inodes contained in that
file. The index should have been 2 in this case, to match the location
of the file on tape.

>> that non-directory files do not reside in the current media and will
>> fail to restore them.
>>
>> The behaviour of an initial restore may succeed if the position of the
>> tape is such that the data file is encountered before the inventory
>> file. Subsequent restores will use the invalid on-line inventory and
>> fail to restore files.
>>
>> Fix this by correctly unpacking the inventory data.
> 
> Which chunk makes this happen?  I'm afraid I'm not that familiar with
> xfsrestore, so I can't really spot where the endian conversion is made.
> Is it that chunk where you remove the "#ifdef INVT_DELETION" (which
> AFAICT is never defined anywhere) and make it so that
> xlate_invt_mediafile is always called?

Yes, I think the code guarded by INVT_DELETION was a work in progress
during the initial port, that it describes this problem suggests they
knew when it would be needed. For Irix it would have worked as is, but
not for anything running on bigendian hardware.

>> Also handle multiple
>> streams and untangle the logic where stobj_unpack_sessinfo is called.
> 
> This sounds like multiple patches to me -- one to fix the missing
> endianness conversion, another to handle the multiple streams, and a
> third to do the cleanup in pi_addfile.
> 

Yes that should make this less confusing.

stobj_unpack_sessinfo() should be the reverse of stobj_pack_sessinfo()
but they don't read that way, I'll see if the session change makes more
seance as part of a clean-up to fix that.

Thanks Darrick!

Don


>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>>   inventory/inv_stobj.c | 38 ++++++++++++++------------------------
>>   restore/content.c     | 13 +++++--------
>>   2 files changed, 19 insertions(+), 32 deletions(-)
>>
>> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
>> index c20e71c..efaf46d 100644
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
>> @@ -1080,35 +1080,25 @@ stobj_unpack_sessinfo(
>>   	p += sizeof(invt_session_t);
>>   
>>   	/* the array of all the streams belonging to this session */
>> -	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
>> -	bcopy(tmpbuf, p, sizeof(invt_stream_t));
>>   	s->strms = (invt_stream_t *)p;
>> -	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
>> +        for (i = 0; i < s->ses->s_cur_nstreams; i++) {
> 
> Indentation damage here.
> 
>> +                xlate_invt_stream((invt_stream_t *)p,
>> +				  (invt_stream_t *)tmpbuf, 1);
>> +                bcopy(tmpbuf, p, sizeof(invt_stream_t));
>> +                p += sizeof(invt_stream_t);
>> +        }
>>   
>>   	/* all the media files */
>>   	s->mfiles = (invt_mediafile_t *)p;
>> -
>> -#ifdef INVT_DELETION
>> -	{
>> -		int tmpfd = open("moids", O_RDWR | O_CREAT, S_IRUSR|S_IWUSR);
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
>> +					     (invt_mediafile_t *)tmpbuf, 1);
>> +			bcopy(tmpbuf, p, sizeof(invt_mediafile_t));
>> +			p +=  sizeof(invt_mediafile_t);
>>   		}
>> -		close(tmpfd);
>>   	}
>> -#endif
>> -	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
>> -		p += (size_t) (s->strms[i].st_nmediafiles)
>> -			* sizeof(invt_mediafile_t);
>> -	}
>> -
>> +	
>>   	/* sanity check the size of the buffer given to us vs. the size it
>>   	   should be */
>>   	if ((size_t) (p - (char *) bufp) != bufsz) {
>> diff --git a/restore/content.c b/restore/content.c
>> index b3999f9..bbced2d 100644
>> --- a/restore/content.c
>> +++ b/restore/content.c
>> @@ -5463,17 +5463,14 @@ pi_addfile(Media_t *Mediap,
>>   			 * desc.
>>   			 */
>>   			sessp = 0;
>> -			if (!buflen) {
>> -				ok = BOOL_FALSE;
>> -			} else {
>> -			    /* extract the session information from the buffer */
>> -			    if (stobj_unpack_sessinfo(bufp, buflen, &sessinfo)<0) {
>> -				ok = BOOL_FALSE;
>> -			    } else {
>> +			ok = BOOL_FALSE;
>> +			/* extract the session information from the buffer */
>> +			if (buflen &&
> 
> There's a lot of trailing whitespace added by this patch.
> 
> Also, what is the purpose of this change?  Is there something
> significant about calling stobj_convert_sessinfo even if
> stobj_unpack_sessinfo returns a negative number?
> 
> *OH* that unpack function returns "bool_t", which means that we only
> care about zero and nonzero.  So I think this is just a cleanup?
> 
> --D
> 
>> +			    stobj_unpack_sessinfo(bufp, buflen, &sessinfo)) {
>>   				stobj_convert_sessinfo(&sessp, &sessinfo);
>>   				ok = BOOL_TRUE;
>> -			    }
>>   			}
>> +
>>   			if (!ok || !sessp) {
>>   				mlog(MLOG_DEBUG | MLOG_WARNING | MLOG_MEDIA, _(
>>   				      "on-media session "
>> -- 
>> 2.31.1
>>
> 

