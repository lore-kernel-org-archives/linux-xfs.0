Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0343BC433E1
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 04:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA990208C3
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 04:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgFSEFE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 00:05:04 -0400
Received: from p10link.net ([80.68.89.68]:43205 "EHLO P10Link.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgFSEFE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jun 2020 00:05:04 -0400
Received: from [192.168.1.2] (unknown [94.2.179.121])
        by P10Link.net (Postfix) with ESMTPSA id 2AB8D40C001
        for <linux-xfs@vger.kernel.org>; Fri, 19 Jun 2020 05:05:01 +0100 (BST)
From:   peter green <plugwash@p10link.net>
Subject: Re: Bug#953537: xfsdump fails to install in /usr merged system.
To:     linux-xfs@vger.kernel.org
Message-ID: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
Date:   Fri, 19 Jun 2020 05:05:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------1C1586CF930C6B7241EAD04C"
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a multi-part message in MIME format.
--------------1C1586CF930C6B7241EAD04C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

(original message was sent to nathans@redhat.com 953537@bugs.debian.org and linux-xfs@vger.kernel.org re-sending as plain-text only to linux-xfs@vger.kernel.org)

This bug has now caused xfsdump to be kicked out of testing which is making amanda unbuildable in testing.


> Yes, what's really needed here is for a change to be merged upstream
> (as all other deb packaging artifacts are) otherwise this will keep
> getting lost in time.
To make it easier to upstream this I whipped up a patch that should solve the issue while only modifying the debian packaging and not touching the upstream makefiles. It is attached to this message and if I get no response I will likely do some further testing and then NMU it in Debian.

One issue I noticed is it's not all all obvious who upstream is. The sgi website listed in README seems to be long dead and there are no obvious upstream results in a google search for xfsdump. Gentoos page on xfsdump links to https://xfs.wiki.kernel.org but that page makes no mention of xfsdump.

I eventually poked around on git.kernel.org and my best guess is that https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/ is the upstream git repository and linux-xfs@vger.kernel.org is the appropriate mailing list, I would appreciate comments on whether or not this is correct and updates to the documentation to reflect whatever the correct location is.

--------------1C1586CF930C6B7241EAD04C
Content-Type: text/plain; charset=UTF-8;
 name="xfsdump.debdiff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="xfsdump.debdiff"

ZGlmZiAtTnJ1IHhmc2R1bXAtMy4xLjkvZGViaWFuL2NoYW5nZWxvZyB4ZnNkdW1wLTMuMS45
K25tdTEvZGViaWFuL2NoYW5nZWxvZwotLS0geGZzZHVtcC0zLjEuOS9kZWJpYW4vY2hhbmdl
bG9nCTIwMjAtMDEtMzEgMTc6MzA6NTguMDAwMDAwMDAwICswMDAwCisrKyB4ZnNkdW1wLTMu
MS45K25tdTEvZGViaWFuL2NoYW5nZWxvZwkyMDIwLTA2LTE5IDAxOjAxOjE4LjAwMDAwMDAw
MCArMDAwMApAQCAtMSwzICsxLDEzIEBACit4ZnNkdW1wICgzLjEuOStubXUxKSBVTlJFTEVB
U0VEOyB1cmdlbmN5PW1lZGl1bQorCisgICogTm9uLW1haW50YWluZXIgdXBsb2FkLgorICAq
IENyZWF0ZSBhbmQgcmVtb3ZlIHN5bWxpbmtzIGluIHBvc3RpbnN0L3ByZWluc3QgcmF0aGVy
IHRoYW4gaW5jbHVkaW5nIHRoZW0KKyAgICBpbiB0aGUgcGFja2FnZSB0byBzdXBwb3J0IG1l
cmdlZCB1c2VyIHN5c3RlbXMuIEJhc2VkIG9uIGEgcGF0Y2ggZnJvbQorICAgIEdvZmZyZWRv
IEJhcm9uY2VsbGkgYnV0IGFkanVzdGVkIHRvIGF2b2lkIHRoZSBuZWVkIGZvciBtb2RpZnlp
bmcgdXBzdHJlYW0KKyAgICBub24tZGViaWFuIGZpbGVzLiAoIENsb3NlczogOTUzNTM3ICkK
KworIC0tIFBldGVyIE1pY2hhZWwgR3JlZW4gPHBsdWd3YXNoQGRlYmlhbi5vcmc+ICBGcmks
IDE5IEp1biAyMDIwIDAxOjAxOjE4ICswMDAwCisKIHhmc2R1bXAgKDMuMS45KSB1bnN0YWJs
ZTsgdXJnZW5jeT1sb3cKIAogICAqIE5ldyB1cHN0cmVhbSByZWxlYXNlCmRpZmYgLU5ydSB4
ZnNkdW1wLTMuMS45L2RlYmlhbi9ydWxlcyB4ZnNkdW1wLTMuMS45K25tdTEvZGViaWFuL3J1
bGVzCi0tLSB4ZnNkdW1wLTMuMS45L2RlYmlhbi9ydWxlcwkyMDIwLTAxLTMxIDE3OjMwOjU4
LjAwMDAwMDAwMCArMDAwMAorKysgeGZzZHVtcC0zLjEuOStubXUxL2RlYmlhbi9ydWxlcwky
MDIwLTA2LTE5IDAxOjAxOjE4LjAwMDAwMDAwMCArMDAwMApAQCAtNDQsNiArNDQsOSBAQAog
CS1ybSAtcmYgJChkaXJtZSkKIAkkKHBrZ21lKSAkKE1BS0UpIC1DIC4gaW5zdGFsbAogCSQo
cGtnbWUpICQoTUFLRSkgZGlzdAorCSNyZW1vdmUgdGhlIHN5bWxpbmtzIGluIC91c3Ivc2Jp
biwgdGhlIHBvc3RpbnN0IHdpbGwgY3JlYXRlIHRoZW0KKwkjaWYgYXBwcm9wcmlhdGUgZm9y
IHRoZSB1c2VycyBzeXN0ZW0gCisJcm0gLWYgZGViaWFuL3hmc2R1bXAvdXNyL3NiaW4veGZz
ZHVtcCBkZWJpYW4veGZzZHVtcC91c3Ivc2Jpbi94ZnNyZXN0b3JlCiAJZGhfaW5zdGFsbGRv
Y3MKIAlkaF9pbnN0YWxsY2hhbmdlbG9ncwogCWRoX3N0cmlwCmRpZmYgLU5ydSB4ZnNkdW1w
LTMuMS45L2RlYmlhbi94ZnNkdW1wLnBvc3RpbnN0IHhmc2R1bXAtMy4xLjkrbm11MS9kZWJp
YW4veGZzZHVtcC5wb3N0aW5zdAotLS0geGZzZHVtcC0zLjEuOS9kZWJpYW4veGZzZHVtcC5w
b3N0aW5zdAkxOTcwLTAxLTAxIDAwOjAwOjAwLjAwMDAwMDAwMCArMDAwMAorKysgeGZzZHVt
cC0zLjEuOStubXUxL2RlYmlhbi94ZnNkdW1wLnBvc3RpbnN0CTIwMjAtMDYtMTkgMDA6NTk6
MzIuMDAwMDAwMDAwICswMDAwCkBAIC0wLDAgKzEsMTIgQEAKKyMhL2Jpbi9zaAorc2V0IC1l
CisKK2lmIFsgIiQxIiA9ICdjb25maWd1cmUnIF07IHRoZW4KKyAgZm9yIGZpbGUgaW4geGZz
ZHVtcCB4ZnNyZXN0b3JlOyBkbworICAgIGlmIFsgISAtZSAvdXNyL3NiaW4vJGZpbGUgXTsg
dGhlbgorICAgICAgbG4gLXMgL3NiaW4vJGZpbGUgL3Vzci9zYmluLyRmaWxlCisgICAgZmkK
KyAgZG9uZQorZmkKKworI0RFQkhFTFBFUiMKZGlmZiAtTnJ1IHhmc2R1bXAtMy4xLjkvZGVi
aWFuL3hmc2R1bXAucHJlaW5zdCB4ZnNkdW1wLTMuMS45K25tdTEvZGViaWFuL3hmc2R1bXAu
cHJlaW5zdAotLS0geGZzZHVtcC0zLjEuOS9kZWJpYW4veGZzZHVtcC5wcmVpbnN0CTE5NzAt
MDEtMDEgMDA6MDA6MDAuMDAwMDAwMDAwICswMDAwCisrKyB4ZnNkdW1wLTMuMS45K25tdTEv
ZGViaWFuL3hmc2R1bXAucHJlaW5zdAkyMDIwLTA2LTE5IDAxOjAxOjE4LjAwMDAwMDAwMCAr
MDAwMApAQCAtMCwwICsxLDEyIEBACisjIS9iaW4vc2gKK3NldCAtZQorCitpZiBbICIkMSIg
PSAncmVtb3ZlJyBdOyB0aGVuCisgIGZvciBmaWxlIGluIHhmc2R1bXAgeGZzcmVzdG9yZTsg
ZG8KKyAgICBpZiBbIC1MIC91c3Ivc2Jpbi8kZmlsZSBdOyB0aGVuCisgICAgICBybSAvdXNy
L3NiaW4vJGZpbGUKKyAgICBmaQorICBkb25lCitmaQorCisjREVCSEVMUEVSIwo=
--------------1C1586CF930C6B7241EAD04C--
