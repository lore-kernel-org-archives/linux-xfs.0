Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35229 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdAPMmx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Jan 2017 07:42:53 -0500
Received: by mail-io0-f181.google.com with SMTP id j18so90597691ioe.2
        for <linux-xfs@vger.kernel.org>; Mon, 16 Jan 2017 04:42:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170113170813.GD23576@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
 <1481117249-21273-10-git-send-email-jtulak@redhat.com> <20170113170813.GD23576@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 16 Jan 2017 13:42:31 +0100
Message-ID: <CACj3i73VEHJtk-GC-B2vNZC27xZRovPY9cy1RUEJ9ZNFPpgJZQ@mail.gmail.com>
Subject: Re: [PATCH 09/22] mkfs: change conflict checks to utilize the new
 conflict structure
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 13, 2017 at 6:08 PM, Bill O'Donnell <billodo@redhat.com> wrote:
> On Wed, Dec 07, 2016 at 02:27:16PM +0100, Jan Tulak wrote:
>> Bring the conflicts detection up to date with conflicts declaration.
>>
>> Signed-off-by: Jan Tulak <jtulak@redhat.com>
>
> There's a missing definition for check_subopt()
> FWIW, I see the call gets removed in patch10.
>
>> ---
>>  mkfs/xfs_mkfs.c | 37 +++++++++++++++++++++++++++++++------
>>  1 file changed, 31 insertions(+), 6 deletions(-)
>>
>> [snip...]
>>
>> @@ -1517,7 +1540,7 @@ getstr(
>>       struct opt_params       *opts,
>>       int                     index)
>>  {
>> -     check_opt(opts, index, true);
>> +     check_subopt(opts, index, true);
>
> check_subopt is undefined. ^^^

Should be renamed to check_subopt_conflicts here, even if it is
deleted in the next patch.

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me
