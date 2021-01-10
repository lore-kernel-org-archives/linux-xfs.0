Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846EAC433E0
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 00:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35B3C2389F
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jan 2021 00:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbhAJA1q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 19:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbhAJA1q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 19:27:46 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A77C061786
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 16:27:05 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1kyOZT-0001ZN-5y; Sun, 10 Jan 2021 00:27:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#979653: xfsprogs: Incomplete debian/copyright
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          979653@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 979653
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: 
References: <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <59b797fa-21b2-b733-88b2-81735bc7d2f5@fishpost.de> <a7a0a016-c031-4532-1292-ad12d16415cf@sandeen.net> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de>
X-Debian-PR-Source: xfsprogs
Received: via spool by 979653-submit@bugs.debian.org id=B979653.16102382465173
          (code B ref 979653); Sun, 10 Jan 2021 00:27:02 +0000
Received: (at 979653) by bugs.debian.org; 10 Jan 2021 00:24:06 +0000
Received: from mail-wr1-x432.google.com ([2a00:1450:4864:20::432]:40880)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1kyOWc-0001JI-6u
        for 979653@bugs.debian.org; Sun, 10 Jan 2021 00:24:06 +0000
Received: by mail-wr1-x432.google.com with SMTP id 91so12577572wrj.7
        for <979653@bugs.debian.org>; Sat, 09 Jan 2021 16:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=M0b6oPlil5yPGrmAXe8XhMvRO0Q3SofDz+8BYrS21lE=;
        b=ITv3yocJT9y2x4pIKQetwIC2r5YhkORy3MR5dHoHP6jmSVzRlvtzBbxr1gZGhSi4y4
         2Gxny/n3haZIAK2j7ggAs/ufa2S5bz7nsNuMUIt5XS4nhmJ29uRhYjhq1MB9Ev0v8LHz
         ydpY/ogjpa4cEGRGPPlro8S1nd+6jK/xyY/F5mNeMmjdfG1it0FZ21uJ5BjBfqgRAPQT
         HMBmPO/uzoLqQTcq8o8ugLZR8ggh6qJqV7/Pvf+pgdaY6xljChxWslpaj6l9Vo7wj/By
         nHiRqwdGdk6DZdiG98g1FyDGLO0OcMzetITJ7psgLlVkfHKKK4V3S/RM+GxrpVbZDtJg
         BfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=M0b6oPlil5yPGrmAXe8XhMvRO0Q3SofDz+8BYrS21lE=;
        b=k3MeINADu3Dh/JkamuJ7w0UcZ1mjcavnXL5Ec2NtNsO893d9JkoRSunQwzCCqqQBHD
         MWSkpJNargZbwgcgvqTToHh3Paotp8gz4Z0xmWsSJaL/KDYWMjLSFRFMYURJcs/P0RIS
         14497RU3DAwtJHpOY6S0YZfm64oZosHKRJAjVsiRS14/IAkCpojJ5DMXIamw9wQ1EHEZ
         BL+yKjut4LhdTxm4a8sLhzBV6g5ohDrIw9PXiesdzN2Qfydx5SVDpWLh/T2r3sHc5YTD
         viD27vrMzr9eORWrfZZi2tyZNdgiQi7L9a64sHnfeIevBZ1LKy23f6qYMtHpefaF1TqD
         vtlg==
X-Gm-Message-State: AOAM532f+X9jClqB/eJbQEqWnS1RDK+H+Mm9Yyit4z0LDympPmfP97tE
        wHitVY42M9ABbXa75lP7lFeyjfO9ATspnvBz
X-Google-Smtp-Source: ABdhPJwaX+QE6rmsFei8oBEV8azGwNL5s+UweoFl6RZGMay/mPELs23QTx5U2DL/upcDr2iYscs2Bg==
X-Received: by 2002:adf:dd09:: with SMTP id a9mr9894455wrm.90.1610238240542;
        Sat, 09 Jan 2021 16:24:00 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:ebbc:e7b1:bde:1433? (p200300d06f355400ebbce7b10bde1433.dip0.t-ipconnect.de. [2003:d0:6f35:5400:ebbc:e7b1:bde:1433])
        by smtp.gmail.com with ESMTPSA id o74sm19140162wme.36.2021.01.09.16.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 16:23:59 -0800 (PST)
To:     Eric Sandeen <sandeen@sandeen.net>, 979653@bugs.debian.org
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <793e1519-b3d9-db3e-4a71-bb6da8ff2ff2@fishpost.de>
Date:   Sun, 10 Jan 2021 01:23:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <a7a0a016-c031-4532-1292-ad12d16415cf@sandeen.net>
Content-Type: multipart/mixed;
 boundary="------------A0EE66045634551A75F97C7D"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------A0EE66045634551A75F97C7D
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.01.21 um 23:53 schrieb Eric Sandeen:
> On 1/9/21 2:42 PM, Bastian Germann wrote:
>> On Sat, 9 Jan 2021 19:31:50 +0100 Bastian Germann <bastiangermann@fishpost.de> wrote:
>>> xfsprogs' debian/copyright only mentions Silicon Graphics, Inc.'s copyright. There are other copyright holders, e.g. Oracle, Red Hat, Google LLC, and several individuals. Please provide a complete copyright file and convert it to the machine-readable format.
>>
>> Please find a copyright file enclosed.
> 
> Hi Bastian -
> 
> I'll take an update to this file, but what are the /minimum/ requirements
> per Debian policy?

https://www.debian.org/doc/debian-policy/ch-archive.html#copyright-considerations

The minimum requirements are that you include the license info.
The copyright info also has to be included in some cases, essentially 
for each file that is included in compiled form in a binary package you 
have to reproduce its copyright info if the license requires the 
copyright to be retained in binary distributions.

> 
> Tracking everything by file+name(s)+year seems rather pointless - it's all
> present in the accompanying source, and keeping it up to date at this
> granularity seems like make-work doomed to be perpetually out of sync.

You can get rid of all the file names. The license info has to be 
included (GPL-2, LGPL-2.1, GPL-3+ with autoconf exception). One can 
argue that the FSF unlimited permission license text (m4/*) also has to 
be included by Policy.

The (L)GPL requires the copyright statements to be included.

I have reduced the given copyright file to a more maintainable version. 
It still keeps some file names (not required) so that one can identify 
the primary copyright holders and the LGPL parts easily.

> I'd prefer to populate it with the minimum required information in
> order to minimize churn and maximize ongoing correctness if possible.
> 
> Thanks,
> -Eric
> 

--------------A0EE66045634551A75F97C7D
Content-Type: text/plain; charset=UTF-8;
 name="copyright"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="copyright"

Rm9ybWF0OiBodHRwczovL3d3dy5kZWJpYW4ub3JnL2RvYy9wYWNrYWdpbmctbWFudWFscy9j
b3B5cmlnaHQtZm9ybWF0LzEuMC8KVXBzdHJlYW0tTmFtZTogeGZzcHJvZ3MKQ29tbWVudDog
VGhpcyBwYWNrYWdlIHdhcyBkZWJpYW5pemVkIGJ5IE5hdGhhbiBTY290dCA8bmF0aGFuc0Bk
ZWJpYW4ub3JnPgpTb3VyY2U6IGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvcHViL2xpbnV4L3V0
aWxzL2ZzL3hmcy94ZnNwcm9ncy8KCkZpbGVzOiAqCkNvcHlyaWdodDoKIDE5OTUtMjAxMyBT
aWxpY29uIEdyYXBoaWNzLCBJbmMuCiAyMDEwLTIwMTggUmVkIEhhdCwgSW5jLgogMjAxNi0y
MDIwIE9yYWNsZS4gIEFsbCBSaWdodHMgUmVzZXJ2ZWQuCkNvbW1lbnQ6IEZvciBtb3N0IGZp
bGVzLCBvbmx5IG9uZSBvZiB0aGUgY29weXJpZ2h0cyBhcHBsaWVzLgpMaWNlbnNlOiBHUEwt
MgoKRmlsZXM6CiBsaWJoYW5kbGUvKi5jCkNvcHlyaWdodDogMTk5NSwgMjAwMS0yMDAyLCAy
MDA1IFNpbGljb24gR3JhcGhpY3MsIEluYy4KQ29tbWVudDogVGhpcyBhbHNvIGFwcGxpZXMg
dG8gc29tZSBoZWFkZXIgZmlsZXMuCkxpY2Vuc2U6IExHUEwtMi4xCiBUaGlzIGxpYnJhcnkg
aXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlm
eSBpdAogdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgTGVzc2VyIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UgYXMgcHVibGlzaGVkIGJ5CiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9u
OyB2ZXJzaW9uIDIuMSBvZiB0aGUgTGljZW5zZS4KIC4KIFRoaXMgbGlicmFyeSBpcyBkaXN0
cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQgV0lUSE9V
VAogQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2Yg
TUVSQ0hBTlRBQklMSVRZIG9yCiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4g
U2VlIHRoZSBHTlUgTGVzc2VyIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKIGZvciBtb3JlIGRl
dGFpbHMuCiAuCiBPbiBEZWJpYW4gc3lzdGVtcywgcmVmZXIgdG8gL3Vzci9zaGFyZS9jb21t
b24tbGljZW5zZXMvTEdQTC0yLjEKIGZvciB0aGUgY29tcGxldGUgdGV4dCBvZiB0aGUgR05V
IExlc3NlciBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlLgoKRmlsZXM6IGNvbmZpZy4qCkNvcHly
aWdodDogMTk5Mi0yMDEzIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbiwgSW5jLgpMaWNlbnNl
OiBHUEwtMysgd2l0aCBhdXRvY29uZiBleGNlcHRpb24KIFRoaXMgZmlsZSBpcyBmcmVlIHNv
ZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0CiB1bmRl
ciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxp
c2hlZCBieQogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24g
MyBvZiB0aGUgTGljZW5zZSwgb3IKIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNp
b24uCiAuCiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBp
dCB3aWxsIGJlIHVzZWZ1bCwgYnV0CiBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBl
dmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mCiBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVT
UyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlIEdOVQogR2VuZXJhbCBQdWJs
aWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgogLgogWW91IHNob3VsZCBoYXZlIHJlY2Vp
dmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKIGFsb25nIHdp
dGggdGhpcyBwcm9ncmFtOyBpZiBub3QsIHNlZSA8aHR0cDovL3d3dy5nbnUub3JnL2xpY2Vu
c2VzLz4uCiAuCiBBcyBhIHNwZWNpYWwgZXhjZXB0aW9uIHRvIHRoZSBHTlUgR2VuZXJhbCBQ
dWJsaWMgTGljZW5zZSwgaWYgeW91CiBkaXN0cmlidXRlIHRoaXMgZmlsZSBhcyBwYXJ0IG9m
IGEgcHJvZ3JhbSB0aGF0IGNvbnRhaW5zIGEKIGNvbmZpZ3VyYXRpb24gc2NyaXB0IGdlbmVy
YXRlZCBieSBBdXRvY29uZiwgeW91IG1heSBpbmNsdWRlIGl0IHVuZGVyCiB0aGUgc2FtZSBk
aXN0cmlidXRpb24gdGVybXMgdGhhdCB5b3UgdXNlIGZvciB0aGUgcmVzdCBvZiB0aGF0CiBw
cm9ncmFtLiAgVGhpcyBFeGNlcHRpb24gaXMgYW4gYWRkaXRpb25hbCBwZXJtaXNzaW9uIHVu
ZGVyIHNlY3Rpb24gNwogb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlLCB2ZXJz
aW9uIDMgKCJHUEx2MyIpLgogLgogT24gRGViaWFuIHN5c3RlbXMsIHRoZSBmdWxsIHRleHQg
b2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIHZlcnNpb24gMwogTGljZW5zZSBj
YW4gYmUgZm91bmQgaW4gL3Vzci9zaGFyZS9jb21tb24tbGljZW5zZXMvR1BMLTMgZmlsZS4K
CkZpbGVzOiBpby9jb3B5X2ZpbGVfcmFuZ2UuYwpDb3B5cmlnaHQ6IDIwMTYgTmV0YXBwLCBJ
bmMuIEFsbCByaWdodHMgcmVzZXJ2ZWQuCkxpY2Vuc2U6IEdQTC0yCgpGaWxlczogaW8vZW5j
cnlwdC5jCkNvcHlyaWdodDogMjAxNiwgMjAxOSBHb29nbGUgTExDCkxpY2Vuc2U6IEdQTC0y
CgpGaWxlczoKIGlvL2xpbmsuYwogbGlieGZzL3hmc19pZXh0X3RyZWUuYwpDb3B5cmlnaHQ6
IDIwMTQsIDIwMTcgQ2hyaXN0b3BoIEhlbGx3aWcuCkxpY2Vuc2U6IEdQTC0yCgpGaWxlczog
aW8vbG9nX3dyaXRlcy5jCkNvcHlyaWdodDogMjAxNyBJbnRlbCBDb3Jwb3JhdGlvbi4KTGlj
ZW5zZTogR1BMLTIKCkZpbGVzOiBpby91dGltZXMuYwpDb3B5cmlnaHQ6IDIwMTYgRGVlcGEg
RGluYW1hbmkKTGljZW5zZTogR1BMLTIKCkZpbGVzOiBsaWJmcm9nL3JhZGl4LXRyZWUuKgpD
b3B5cmlnaHQ6CiAyMDAxIE1vbWNoaWwgVmVsaWtvdgogMjAwMSBDaHJpc3RvcGggSGVsbHdp
ZwogMjAwNSBTR0ksIENocmlzdG9waCBMYW1ldGVyIDxjbGFtZXRlckBzZ2kuY29tPgpMaWNl
bnNlOiBHUEwtMgoKRmlsZXM6IGxpYnhmcy94ZnNfbG9nX3JsaW1pdC5jCkNvcHlyaWdodDog
MjAxMyBKaWUgTGl1LgpMaWNlbnNlOiBHUEwtMgoKTGljZW5zZTogR1BMLTIKIFRoaXMgcHJv
Z3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3Ig
bW9kaWZ5IGl0IHVuZGVyCiB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBM
aWNlbnNlIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZQogRm91bmRhdGlvbjsg
dmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLgogLgogVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1
dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsIGJ1dCBXSVRIT1VUCiBB
TlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZiBNRVJD
SEFOVEFCSUxJVFkgb3IgRklUTkVTUwogRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2Vl
IHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgogLgog
WW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVi
bGljIExpY2Vuc2UgYWxvbmcgd2l0aAogdGhpcyBwYWNrYWdlOyBpZiBub3QsIHdyaXRlIHRv
IHRoZSBGcmVlIFNvZnR3YXJlIEZvdW5kYXRpb24sIEluYy4sIDUxIEZyYW5rbGluCiBTdCwg
RmlmdGggRmxvb3IsIEJvc3RvbiwgTUEgIDAyMTEwLTEzMDEgVVNBCiAuCiBPbiBEZWJpYW4g
c3lzdGVtcywgdGhlIGZ1bGwgdGV4dCBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgdmVyc2lvbiAyCiBMaWNlbnNlIGNhbiBiZSBmb3VuZCBpbiAvdXNyL3NoYXJlL2NvbW1v
bi1saWNlbnNlcy9HUEwtMiBmaWxlLgo=
--------------A0EE66045634551A75F97C7D--
