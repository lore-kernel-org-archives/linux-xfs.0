Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-eopbgr30103.outbound.protection.outlook.com ([40.107.3.103]:29919
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759940AbdEXMY1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 08:24:27 -0400
From: =?utf-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Wed, 24 May 2017 12:24:24 +0000
Message-ID: <5860842.KKjOuUXKLI@libor-nb>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <b6492357-4bf3-c570-be33-90010e3b1967@sandeen.net>
 <4648960.1DrcVCcZxK@libor-nb>
In-Reply-To: <4648960.1DrcVCcZxK@libor-nb>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6ECB732683D384ABAC0CE6F8C630D30@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

SGVsbG8sCgpPbiBzdMWZZWRhIDI0LiBrdsSbdG5hIDIwMTcgMTM6MTg6NDcgQ0VTVCBMaWJvciBL
bGVww6HEjSB3cm90ZToKPiBIaSwKPiBhZnRlciBxdWlldCB0d28gbW9udGhzICwgYW5vdGhlciBj
cmFzaCwgdHJhY2UgaXMgc2FtZSBhcyBiZWZvcmUuCj4gVGhlcmUgYXJlIG5vIFhGUyBsaW5lcyBi
ZWZvcmUgdGhpcywga2Vybi5sb2cgZ29lcyBiYWNrIHRvIDIzLiBhcHJpbC4KPiAKLS0tc25pcCB0
cmFjZS0tLS0KPiAKPiBBZnRlciBmaWxlc3lzdGVtIHNodXRkb3duLCBiZWZvcmUgcmVib290IGkg
aGF2ZSB1cGdyYWRlZCBrZXJuZWwgdG8gCjQuOS4yNS0xfmJwbzgrMQo+IAo+IEN1c3RvbWVyIHdh
cyBjYWxsaW5nIHVzLCBqdXN0IHdoZW4gbmFnaW9zIGFsZXJ0ZWQgdXMgb24gaG9zdCBwcm9ibGVt
LCB0aGF0IApoZSB3YXMgY29weWluZyBzb21lIGZpbGVzIGJldHdlZW4gYWNjb3VudHMgKHdoaWNo
IG1lYW5zIGNoYW5naW5nIGFjbHMpLCBpIGhhdmUgCmFza2VkIGhpbSBmb3IgbW9yZSBpbmZvcm1h
dGlvbi4KClNvIGFjY29yZGluZyB0byBjdXN0b21lciwgaGUgd2FzIG9uIHNzaCBhbmQgd2FzIGNv
cHlpbmcgZmlsZXMgZnJvbSBvbmUgCmN1c3RvbWVyIGFjY291bnQgdG8gYW5vdGhlciBkZWRpY2F0
ZWQgZm9yIGRldmVsb3BtZW50LCB1c2luZyBtaWRuaWdodCAKY29tbWFuZGVyLgpJdCBpbnZvbHZl
cyBjaGFuZ2luZyBmaWxlIEFDTHMuCgpvcmlnaW5hbCBkaXIgYWNsCgojI2dldGZhY2wgLgojIGZp
bGU6IC4KIyBvd25lcjogY3VzdDEKIyBncm91cDogY3VzdDEKIyBmbGFnczogLXMtCnVzZXI6OnJ3
eAp1c2VyOmJhY2t1cDotLXgKdXNlcjpjdXN0MTpyd3gKZ3JvdXA6OnJ3eApncm91cDp3d3ctZGF0
YTpyLXgKZ3JvdXA6Y3VzdDE6cnd4Cm1hc2s6OnJ3eApvdGhlcjo6LS0tCmRlZmF1bHQ6dXNlcjo6
cnd4CmRlZmF1bHQ6dXNlcjpiYWNrdXA6LS14CmRlZmF1bHQ6dXNlcjpjdXN0MTpyd3gKZGVmYXVs
dDpncm91cDo6cnd4CmRlZmF1bHQ6Z3JvdXA6d3d3LWRhdGE6ci14CmRlZmF1bHQ6Z3JvdXA6Y3Vz
dDE6cnd4CmRlZmF1bHQ6bWFzazo6cnd4CmRlZmF1bHQ6b3RoZXI6OnIteAoKZGVzdGluYXRpb24g
ZGlyIGFjbHMKIyBnZXRmYWNsIC4KIyBmaWxlOiAuCiMgb3duZXI6IGFkbWluLXNzaAojIGdyb3Vw
OiB3d3ctZGF0YQp1c2VyOjpyd3gKdXNlcjpiYWNrdXA6LS14Cmdyb3VwOjpyd3gKZ3JvdXA6d3d3
LWRhdGE6cnd4Cm1hc2s6OnJ3eApvdGhlcjo6ci14CmRlZmF1bHQ6dXNlcjo6cnd4CmRlZmF1bHQ6
dXNlcjpiYWNrdXA6LS14CmRlZmF1bHQ6Z3JvdXA6OnJ3eApkZWZhdWx0Omdyb3VwOnd3dy1kYXRh
OnJ3eApkZWZhdWx0Om1hc2s6OnJ3eApkZWZhdWx0Om90aGVyOjpyLXgKCgotLS0tCgp1c2VyIGFk
bWluLXNzaCBpcyBtZW1iZXIgb2Ygd3d3LWRhdGEgZ3JvdXAgc28gaGUgY2FuIGNvcHkgZnJvbSBj
dXN0b21lciBkaXIKCkxpYm9yCg==
