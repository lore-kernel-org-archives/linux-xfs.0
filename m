Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2946 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753200AbdJSOxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 10:53:01 -0400
From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: Fix false positive by LOCKDEP_CROSSRELEASE
Date: Thu, 19 Oct 2017 14:52:56 +0000
Message-ID: <1508424774.2429.1.camel@wdc.com>
References: <1508319532-24655-1-git-send-email-byungchul.park@lge.com>
         <1508336995.2923.2.camel@wdc.com> <20171019015705.GD32368@X58A-UD3R>
In-Reply-To: <20171019015705.GD32368@X58A-UD3R>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <65485D8A1A7E2F488AC2566D9B74AA48@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "byungchul.park@lge.com" <byungchul.park@lge.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "hch@infradead.org" <hch@infradead.org>, "amir73il@gmail.com" <amir73il@gmail.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "oleg@redhat.com" <oleg@redhat.com>, "darrick.wong@oracle.com" <darrick.wong@oracle.com>, "johannes.berg@intel.com" <johannes.berg@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, "tj@kernel.org" <tj@kernel.org>, "kernel-team@lge.com" <kernel-team@lge.com>, "david@fromorbit.com" <david@fromorbit.com>

T24gVGh1LCAyMDE3LTEwLTE5IGF0IDEwOjU3ICswOTAwLCBCeXVuZ2NodWwgUGFyayB3cm90ZToN
Cj4gT24gV2VkLCBPY3QgMTgsIDIwMTcgYXQgMDI6Mjk6NTZQTSArMDAwMCwgQmFydCBWYW4gQXNz
Y2hlIHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAxNy0xMC0xOCBhdCAxODozOCArMDkwMCwgQnl1bmdj
aHVsIFBhcmsgd3JvdGU6DQo+ID4gPiBTZXZlcmFsIGZhbHNlIHBvc2l0aXZlcyB3ZXJlIHJlcG9y
dGVkLCBzbyBJIHRyaWVkIHRvIGZpeCB0aGVtLg0KPiA+ID4gDQo+ID4gPiBJdCB3b3VsZCBiZSBh
cHByZWNpYXRlZCBpZiB5b3UgdGVsbCBtZSBpZiBpdCB3b3JrcyBhcyBleHBlY3RlZCwgb3IgbGV0
DQo+ID4gPiBtZSBrbm93IHlvdXIgb3Bpbmlvbi4NCj4gPiANCj4gPiBXaGF0IEkgaGF2ZSBiZWVu
IHdvbmRlcmluZyBhYm91dCBpcyB3aGV0aGVyIHRoZSBjcm9zc2xvY2sgY2hlY2tpbmcgbWFrZXMN
Cj4gPiBzZW5zZSBmcm9tIGEgY29uY2VwdHVhbCBwb2ludCBvZiB2aWV3LiBJIHRyaWVkIHRvIGZp
bmQgZG9jdW1lbnRhdGlvbiBmb3IgdGhlDQo+ID4gY3Jvc3Nsb2NrIGNoZWNraW5nIGluIERvY3Vt
ZW50YXRpb24vbG9ja2luZy9sb2NrZGVwLWRlc2lnbi50eHQgYnV0DQo+ID4gY291bGRuJ3QgZmlu
ZCBhIGRlc2NyaXB0aW9uIG9mIHRoZSBjcm9zc2xvY2sgY2hlY2tpbmcuIFNob3VsZG4ndCBpdCBi
ZQ0KPiA+IGRvY3VtZW50ZWQgc29tZXdoZXJlIHdoYXQgdGhlIGNyb3NzbG9jayBjaGVja3MgZG8g
YW5kIHdoYXQgdGhlIHRoZW9yeSBpcw0KPiA+IGJlaGluZCB0aGVzZSBjaGVja3M/DQo+IA0KPiBE
b2N1bWVudGF0aW9uL2xvY2tpbmcvY3Jvc3NyZWxlYXNlLnR4dCB3b3VsZCBiZSBoZWxwZnVsLg0K
DQpUaGF0IGRvY3VtZW50IGlzIGluY29tcGxldGUuIEl0IGRvZXMgbm90IG1lbnRpb24gdGhhdCBh
bHRob3VnaCBpdCBjYW4gYmUNCnByb3ZlbiB0aGF0IHRoZSB0cmFkaXRpb25hbCBsb2NrIHZhbGlk
YXRpb24gY29kZSB3b24ndCBwcm9kdWNlIGZhbHNlDQpwb3NpdGl2ZXMsIHRoYXQgdGhlIGNyb3Nz
LXJlbGVhc2UgY2hlY2tzIGRvIG5vdCBoYXZlIGEgc29saWQgdGhlb3JldGljYWwNCmZvdW5kYXRp
b24gYW5kIGFyZSBwcm9uZSB0byBwcm9kdWNlIGZhbHNlIHBvc2l0aXZlIHJlcG9ydHMuDQoNCkJh
cnQu
