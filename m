Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5621CC433DB
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 20:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF72F23B00
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 20:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbhAIUpp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 15:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbhAIUpo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 15:45:44 -0500
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEE3C061786
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jan 2021 12:45:04 -0800 (PST)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1kyL6d-0006iJ-9x; Sat, 09 Jan 2021 20:45:03 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#979653: xfsprogs: Incomplete debian/copyright
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          979653@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 979653
X-Debian-PR-Package: src:xfsprogs
X-Debian-PR-Keywords: 
References: <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de> <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de>
X-Debian-PR-Source: xfsprogs
Received: via spool by 979653-submit@bugs.debian.org id=B979653.161022498524378
          (code B ref 979653); Sat, 09 Jan 2021 20:45:02 +0000
Received: (at 979653) by bugs.debian.org; 9 Jan 2021 20:43:05 +0000
Received: from mail-wr1-x42e.google.com ([2a00:1450:4864:20::42e]:40903)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1kyL4i-0006Km-IP
        for 979653@bugs.debian.org; Sat, 09 Jan 2021 20:43:05 +0000
Received: by mail-wr1-x42e.google.com with SMTP id 91so12321944wrj.7
        for <979653@bugs.debian.org>; Sat, 09 Jan 2021 12:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:references:subject:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=Po7cC7zNKQ3kq+RZ3B/Ot7uwfZCRa9eX01hDF9XFHuI=;
        b=1LFyrFsLFYSqzasagQmG3RmI01B9pk46gCMRF+ao5ENJpCS9ajL13BU+WCpVBIyRwf
         Idki5XvXJR/r+m5xmSKVIh0mDvKNSwzlZHnLtQ5IX5t19qqUtqZ1O3TXhLk2+lFyToF7
         TZrCctIKlce80Y5Z5kuCnSq0Xo3/ZD7MwPwc0SA6sFvlfE9+M5W4/0DzEOZy3hSyju8I
         0lgUAUdZRtWjO1ttARsFwWKD4NXkG9ejs7o/J7yA3PhHWzTdgqELr71eDXnSSIKyciEO
         41A9MIPsJbmgPuN9WfiTvuqYR1EOzYRZkzdLWte3wNxSo1AWCXZLn9i/fGGQtslnEqGo
         /Czg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:subject:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=Po7cC7zNKQ3kq+RZ3B/Ot7uwfZCRa9eX01hDF9XFHuI=;
        b=psKUkBaJfvfWy31Xp7jDsbY0yamoI/sJFP5ZMWwEmzygidlsXgQx2w/HnNVqnOpPz0
         tatUrRQpkOINYQbpT6icx96H9R7J36h9HpnJmSSg40ucss/5Q8jYg7nOZkwssR9pemxo
         El6f8WbzdmK7BT8DwBaUHwv9aHJDRdCQ2honCVDH1SoV2KvinCNLXDHkwOOYF7Pq80b/
         vXh6W+SifmCXkUZwAZUNtSGTRnFP0NBaU64mOCztlnnnyZTg4SxJDVJDvB5AVuNNVqpm
         49xhWZOukib7ZzYmia9fM3AKdE/T0ujlK48oBgdwVAcA0O4dwmUGIgeKSYnRu1Sg38xv
         7b3w==
X-Gm-Message-State: AOAM532p8J5B1SBeGYkDsrXq29l40tSTPQcflzsSk+WjWNZ6wefL3klE
        ngEmsTP/s+kiDawmCRA3TxWX+Mcqu736iDPb
X-Google-Smtp-Source: ABdhPJxYKn7iJsZoNFZoyPQ1krFdvDAq29VnduMzxULF0zdNQcvAehs/pi31Mlbiydck83DYLpq0kQ==
X-Received: by 2002:a05:6000:100f:: with SMTP id a15mr9478880wrx.300.1610224980858;
        Sat, 09 Jan 2021 12:43:00 -0800 (PST)
Received: from ?IPv6:2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27? (p200300d06f3554009d4aa26f7cc66e27.dip0.t-ipconnect.de. [2003:d0:6f35:5400:9d4a:a26f:7cc6:6e27])
        by smtp.gmail.com with ESMTPSA id o125sm16663240wmo.30.2021.01.09.12.42.59
        for <979653@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 12:43:00 -0800 (PST)
To:     979653@bugs.debian.org
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <59b797fa-21b2-b733-88b2-81735bc7d2f5@fishpost.de>
Date:   Sat, 9 Jan 2021 21:42:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <90d12c70-6679-85aa-b835-e2db9d1eb441@fishpost.de>
Content-Type: multipart/mixed;
 boundary="------------38F6BBC5B79201439128DD68"
Content-Language: de-DE-frami
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------38F6BBC5B79201439128DD68
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On Sat, 9 Jan 2021 19:31:50 +0100 Bastian Germann 
<bastiangermann@fishpost.de> wrote:
> xfsprogs' debian/copyright only mentions Silicon Graphics, Inc.'s 
> copyright. There are other copyright holders, e.g. Oracle, Red Hat, 
> Google LLC, and several individuals. Please provide a complete copyright 
> file and convert it to the machine-readable format.

Please find a copyright file enclosed.

--------------38F6BBC5B79201439128DD68
Content-Type: text/plain; charset=UTF-8;
 name="copyright"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="copyright"

Rm9ybWF0OiBodHRwczovL3d3dy5kZWJpYW4ub3JnL2RvYy9wYWNrYWdpbmctbWFudWFscy9j
b3B5cmlnaHQtZm9ybWF0LzEuMC8KVXBzdHJlYW0tTmFtZTogeGZzcHJvZ3MKQ29tbWVudDog
VGhpcyBwYWNrYWdlIHdhcyBkZWJpYW5pemVkIGJ5IE5hdGhhbiBTY290dCA8bmF0aGFuc0Bk
ZWJpYW4ub3JnPgpTb3VyY2U6IGh0dHBzOi8vd3d3Lmtlcm5lbC5vcmcvcHViL2xpbnV4L3V0
aWxzL2ZzL3hmcy94ZnNwcm9ncy8KCkZpbGVzOiAqCkNvcHlyaWdodDogMTk5NS0yMDEzIFNp
bGljb24gR3JhcGhpY3MsIEluYy4KTGljZW5zZTogR1BMLTIKCkZpbGVzOgogaW5jbHVkZS9o
YW5kbGUuaAogaW5jbHVkZS9qZG0uaAogaW5jbHVkZS9saW51eC5oCiBpbmNsdWRlL3BhcmVu
dC5oCiBpbmNsdWRlL3BsYXRmb3JtX2RlZnMuaC5pbgogaW5jbHVkZS94ZnMuaAogaW5jbHVk
ZS94ZnNfZnNfY29tcGF0LmgKIGluY2x1ZGUveHFtLmgKIGxpYmhhbmRsZS9oYW5kbGUuYwog
bGliaGFuZGxlL2pkbS5jCiBsaWJ4ZnMveGZzX2ZzLmgKQ29weXJpZ2h0OiAxOTk1LTIwMTMg
U2lsaWNvbiBHcmFwaGljcywgSW5jLgpMaWNlbnNlOiBMR1BMLTIuMQogVGhpcyBsaWJyYXJ5
IGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2Rp
ZnkgaXQKIHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIExlc3NlciBHZW5lcmFsIFB1Ymxp
YyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlv
bjsgZWl0aGVyIHZlcnNpb24gMi4xIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQKIHlvdXIgb3B0
aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KIC4KIFRoaXMgbGlicmFyeSBpcyBkaXN0cmlidXRl
ZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQgV0lUSE9VVAogQU5Z
IFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YgTUVSQ0hB
TlRBQklMSVRZIG9yCiBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gU2VlIHRo
ZSBHTlUgTGVzc2VyIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKIGZvciBtb3JlIGRldGFpbHMu
CiAuCiBPbiBEZWJpYW4gc3lzdGVtcywgcmVmZXIgdG8gL3Vzci9zaGFyZS9jb21tb24tbGlj
ZW5zZXMvTEdQTC0yLjEKIGZvciB0aGUgY29tcGxldGUgdGV4dCBvZiB0aGUgR05VIExlc3Nl
ciBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlLgoKRmlsZXM6IGNvbmZpZy4qCkNvcHlyaWdodDog
MTk5Mi0yMDEzIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbiwgSW5jLgpMaWNlbnNlOiBHUEwt
Mysgd2l0aCBhdXRvY29uZiBleGNlcHRpb24KIFRoaXMgZmlsZSBpcyBmcmVlIHNvZnR3YXJl
OyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0CiB1bmRlciB0aGUg
dGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBi
eQogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMyBvZiB0
aGUgTGljZW5zZSwgb3IKIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCiAu
CiBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxs
IGJlIHVzZWZ1bCwgYnV0CiBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRo
ZSBpbXBsaWVkIHdhcnJhbnR5IG9mCiBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1Ig
QSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlIEdOVQogR2VuZXJhbCBQdWJsaWMgTGlj
ZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgogLgogWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEg
Y29weSBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKIGFsb25nIHdpdGggdGhp
cyBwcm9ncmFtOyBpZiBub3QsIHNlZSA8aHR0cDovL3d3dy5nbnUub3JnL2xpY2Vuc2VzLz4u
CiAuCiBBcyBhIHNwZWNpYWwgZXhjZXB0aW9uIHRvIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMg
TGljZW5zZSwgaWYgeW91CiBkaXN0cmlidXRlIHRoaXMgZmlsZSBhcyBwYXJ0IG9mIGEgcHJv
Z3JhbSB0aGF0IGNvbnRhaW5zIGEKIGNvbmZpZ3VyYXRpb24gc2NyaXB0IGdlbmVyYXRlZCBi
eSBBdXRvY29uZiwgeW91IG1heSBpbmNsdWRlIGl0IHVuZGVyCiB0aGUgc2FtZSBkaXN0cmli
dXRpb24gdGVybXMgdGhhdCB5b3UgdXNlIGZvciB0aGUgcmVzdCBvZiB0aGF0CiBwcm9ncmFt
LiAgVGhpcyBFeGNlcHRpb24gaXMgYW4gYWRkaXRpb25hbCBwZXJtaXNzaW9uIHVuZGVyIHNl
Y3Rpb24gNwogb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlLCB2ZXJzaW9uIDMg
KCJHUEx2MyIpLgogLgogT24gRGViaWFuIHN5c3RlbXMsIHRoZSBmdWxsIHRleHQgb2YgdGhl
IEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIHZlcnNpb24gMwogTGljZW5zZSBjYW4gYmUg
Zm91bmQgaW4gL3Vzci9zaGFyZS9jb21tb24tbGljZW5zZXMvR1BMLTMgZmlsZS4KCkZpbGVz
Ogogc3BhY2VtYW4vZnJlZXNwLmMKQ29weXJpZ2h0OgogMjAwMC0yMDAxLDIwMDUgU2lsaWNv
biBHcmFwaGljcywgSW5jLgogMjAxMiBSZWQgSGF0LCBJbmMuCiAyMDE3IE9yYWNsZS4KTGlj
ZW5zZTogR1BMLTIKCkZpbGVzOgogZGIvYnRkdW1wLmMKIGRiL2J0aGVpZ2h0LmMKIGRiL2Zz
bWFwLioKIGRiL2Z1enouaAogZGIvaW5mby5jCiBkYi90aW1lbGltaXQuYwogaW8vYnVsa3N0
YXQuYwogaW8vY293ZXh0c2l6ZS5jCiBpby9jcmMzMmNzZWxmdGVzdC5jCiBpby9mc21hcC5j
CiBpby9yZWZsaW5rLmMKIGlvL3NjcnViLmMKIGxpYmZyb2cvTWFrZWZpbGUKIGxpYmZyb2cv
Yml0bWFwLioKIGxpYmZyb2cvYnVsa3N0YXQuKgogbGliZnJvZy9sb2dnaW5nLioKIGxpYmZy
b2cvcHR2YXIuKgogbGliZnJvZy9zY3J1Yi4qCiBsaWJmcm9nL3dvcmtxdWV1ZS4qCiBsaWJ4
ZnMvZGVmZXJfaXRlbS5jCiBsaWJ4ZnMveGZzX2FnX3Jlc3YuKgogbGlieGZzL3hmc19idHJl
ZV9zdGFnaW5nLioKIGxpYnhmcy94ZnNfZGVmZXIuKgogbGlieGZzL3hmc19lcnJvcnRhZy5o
CiBsaWJ4ZnMveGZzX2hlYWx0aC5oCiBsaWJ4ZnMveGZzX3JlZmNvdW50LioKIGxpYnhmcy94
ZnNfcmVmY291bnRfYnRyZWUuKgogbGlieGZzL3hmc19ybWFwLmgKIGxpYnhmcy94ZnNfdHlw
ZXMuYwogbG9ncHJpbnQvbG9nX3JlZG8uYwogbWFuL21hbjIvaW9jdGxfeGZzXyouMgogcmVw
YWlyL2FnYnRyZWUuKgogcmVwYWlyL2J1bGtsb2FkLioKIHJlcGFpci9xdW90YWNoZWNrLioK
IHJlcGFpci9ybWFwLioKIHJlcGFpci9zbGFiLioKIHNjcnViLyoKIHNwYWNlbWFuL2hlYWx0
aC5jCiBzcGFjZW1hbi9pbmZvLmMKIHRvb2xzL3hmc2J1ZmxvY2sucHkKQ29weXJpZ2h0OiAy
MDE2LTIwMjAgT3JhY2xlLiAgQWxsIFJpZ2h0cyBSZXNlcnZlZC4KTGljZW5zZTogR1BMLTIK
CkZpbGVzOgogZGIvY3JjLioKIGRiL2xvZ2Zvcm1hdC4qCiBkYi9zeW1saW5rLioKIGluY2x1
ZGUvYXRvbWljLmgKIGluY2x1ZGUveGZzX3RyYWNlLmgKIGlvL2ZpZW1hcC5jCiBpby9sYWJl
bC5jCiBpby9yZWFkZGlyLmMKIGlvL3N0YXQuYwogaW8vc3dhcGV4dC5jCiBpby9zeW5jLmMK
IGlvL3N5bmNfZmlsZV9yYW5nZS5jCiBzcGFjZW1hbi9NYWtlZmlsZQogc3BhY2VtYW4vZmls
ZS5jCiBzcGFjZW1hbi9pbml0LmMKIHNwYWNlbWFuL2luaXQuaAogc3BhY2VtYW4vcHJlYWxs
b2MuYwogc3BhY2VtYW4vc3BhY2UuaAogc3BhY2VtYW4vdHJpbS5jCiBsaWJ4ZnMvdHJhbnMu
YwogbGlieGZzL3hmc19hZy4qCiBsaWJ4ZnMveGZzX2F0dHJfbGVhZi4qCiBsaWJ4ZnMveGZz
X2F0dHJfcmVtb3RlLioKIGxpYnhmcy94ZnNfZGFfYnRyZWUuKgogbGlieGZzL3hmc19kYV9m
b3JtYXQuaAogbGlieGZzL3hmc19kaXIyX2Jsb2NrLmMKIGxpYnhmcy94ZnNfZGlyMl9kYXRh
LmMKIGxpYnhmcy94ZnNfZGlyMl9sZWFmLmMKIGxpYnhmcy94ZnNfZGlyMl9ub2RlLmMKIGxp
Ynhmcy94ZnNfZHF1b3RfYnVmLmMKIGxpYnhmcy94ZnNfcm1hcC5jCiBsaWJ4ZnMveGZzX3Jt
YXBfYnRyZWUuKgogbGlieGZzL3hmc19zaGFyZWQuaAogbGlieGZzL3hmc19zeW1saW5rX3Jl
bW90ZS5jCiBsaWJ4ZnMveGZzX3RyYW5zX3Jlc3YuYwogcmVwYWlyL2RhX3V0aWwuKgpDb3B5
cmlnaHQ6IDIwMTAtMjAxOCBSZWQgSGF0LCBJbmMuCkxpY2Vuc2U6IEdQTC0yCgpGaWxlczog
aW8vY29weV9maWxlX3JhbmdlLmMKQ29weXJpZ2h0OiAyMDE2IE5ldGFwcCwgSW5jLiBBbGwg
cmlnaHRzIHJlc2VydmVkLgpMaWNlbnNlOiBHUEwtMgoKRmlsZXM6IGlvL2VuY3J5cHQuYwpD
b3B5cmlnaHQ6IDIwMTYsIDIwMTkgR29vZ2xlIExMQwpMaWNlbnNlOiBHUEwtMgoKRmlsZXM6
CiBpby9saW5rLmMKIGxpYnhmcy94ZnNfaWV4dF90cmVlLmMKQ29weXJpZ2h0OiAyMDE0LCAy
MDE3IENocmlzdG9waCBIZWxsd2lnLgpMaWNlbnNlOiBHUEwtMgoKRmlsZXM6IGlvL2xvZ193
cml0ZXMuYwpDb3B5cmlnaHQ6IDIwMTcgSW50ZWwgQ29ycG9yYXRpb24uCkxpY2Vuc2U6IEdQ
TC0yCgpGaWxlczogaW8vdXRpbWVzLmMKQ29weXJpZ2h0OiAyMDE2IERlZXBhIERpbmFtYW5p
CkxpY2Vuc2U6IEdQTC0yCgpGaWxlczogbGliZnJvZy9jcmMzMioKQ29weXJpZ2h0OiAobm9u
ZSwgdmFyaW91cyBhdXRob3JzIG1lbnRpb25lZCkKTGljZW5zZTogR1BMLTIKCkZpbGVzOiBs
aWJmcm9nL3JhZGl4LXRyZWUuKgpDb3B5cmlnaHQ6CiAyMDAxIE1vbWNoaWwgVmVsaWtvdgog
MjAwMSBDaHJpc3RvcGggSGVsbHdpZwogMjAwNSBTR0ksIENocmlzdG9waCBMYW1ldGVyIDxj
bGFtZXRlckBzZ2kuY29tPgpMaWNlbnNlOiBHUEwtMgoKRmlsZXM6CiBsdG1haW4uc2gKIG00
L2xpYnRvb2wubTQKQ29weXJpZ2h0OiAxOTk2LTIwMTEgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0
aW9uLCBJbmMuCkxpY2Vuc2U6IEdQTC0yCgpGaWxlczogbGlieGZzL3hmc19sb2dfcmxpbWl0
LmMKQ29weXJpZ2h0OiAyMDEzIEppZSBMaXUuCkxpY2Vuc2U6IEdQTC0yCgpGaWxlczogcG8v
ZGUucG8KQ29weXJpZ2h0OiBDaHJpcyBMZWljayA8Yy5sZWlja0B2b2xsYmlvLmRlPiwgMjAw
OS4KTGljZW5zZTogR1BMLTIKCkxpY2Vuc2U6IEdQTC0yCiBUaGlzIHByb2dyYW0gaXMgZnJl
ZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeSBpdCB1
bmRlcgogdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBw
dWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUKIEZvdW5kYXRpb247IHZlcnNpb24gMiBv
ZiB0aGUgTGljZW5zZS4KIC4KIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUg
aG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLCBidXQgV0lUSE9VVAogQU5ZIFdBUlJBTlRZ
OyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YgTUVSQ0hBTlRBQklMSVRZ
IG9yIEZJVE5FU1MKIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUgR05VIEdl
bmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KIC4KIFlvdSBzaG91bGQg
aGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
IGFsb25nIHdpdGgKIHRoaXMgcGFja2FnZTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBT
b2Z0d2FyZSBGb3VuZGF0aW9uLCBJbmMuLCA1MSBGcmFua2xpbgogU3QsIEZpZnRoIEZsb29y
LCBCb3N0b24sIE1BICAwMjExMC0xMzAxIFVTQQogLgogT24gRGViaWFuIHN5c3RlbXMsIHRo
ZSBmdWxsIHRleHQgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIHZlcnNpb24g
MgogTGljZW5zZSBjYW4gYmUgZm91bmQgaW4gL3Vzci9zaGFyZS9jb21tb24tbGljZW5zZXMv
R1BMLTIgZmlsZS4K
--------------38F6BBC5B79201439128DD68--
