Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbfBGIQ4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 03:16:56 -0500
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
References: <87h8dgefee.fsf@esperi.org.uk>
From: Coly Li <colyli@suse.de>
Message-ID: <64f32487-5b8f-f6c2-37a9-84bb0717a9e1@suse.de>
Date: Thu, 7 Feb 2019 16:16:48 +0800
MIME-Version: 1.0
In-Reply-To: <87h8dgefee.fsf@esperi.org.uk>
Content-Type: multipart/mixed;
 boundary="------------0BFDCE4D32CD1F8FB50BD466"
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nix <nix@esperi.org.uk>
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Andre Noll <maan@tuebingen.mpg.de>

This is a multi-part message in MIME format.
--------------0BFDCE4D32CD1F8FB50BD466
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 2019/2/7 6:11 上午, Nix wrote:
> So I just upgraded to 4.20 and revived my long-turned-off bcache now
> that the metadata corruption leading to mount failure on dirty close may
> have been identified (applying Tang Junhui's patch to do so)... and I
> spotted something a bit disturbing. It appears that XFS directory and
> metadata I/O is going more or less entirely uncached.
> 
> Here's some bcache stats before and after a git status of a *huge*
> uncached tree (Chromium) on my no-writeback readaround cache. It takes
> many minutes and pounds the disk with massively seeky metadata I/O in
> the process:
> 
> Before:
> 
> stats_total/bypassed: 48.3G
> stats_total/cache_bypass_hits: 7942
> stats_total/cache_bypass_misses: 861045
> stats_total/cache_hit_ratio: 3
> stats_total/cache_hits: 16286
> stats_total/cache_miss_collisions: 25
> stats_total/cache_misses: 411575
> stats_total/cache_readaheads: 0
> 
> After:
> stats_total/bypassed: 49.3G
> stats_total/cache_bypass_hits: 7942
> stats_total/cache_bypass_misses: 1154887
> stats_total/cache_hit_ratio: 3
> stats_total/cache_hits: 16291
> stats_total/cache_miss_collisions: 25
> stats_total/cache_misses: 411625
> stats_total/cache_readaheads: 0
> 
> Huge increase in bypassed reads, essentially no new cached reads. This
> is... basically the optimum case for bcache, and it's not caching it!
> 
> From my reading of xfs_dir2_leaf_readbuf(), it looks like essentially
> all directory reads in XFS appear to bcache as a single non-readahead
> followed by a pile of readahead I/O: bcache bypasses readahead bios, so
> all directory reads (or perhaps all directory reads larger than a single
> block) are going to be bypassed out of hand.
> 
> This seems... suboptimal, but so does filling up the cache with
> read-ahead blocks (particularly for non-metadata) that are never used.
> Anyone got any ideas, 'cos I'm currently at a loss: XFS doesn't appear
> to let us distinguish between "read-ahead just in case but almost
> certain to be accessed" (like directory blocks) and "read ahead on the
> offchance because someone did a single-block file read and what the hell
> let's suck in a bunch more".
> 
> As it is, this seems to render bcache more or less useless with XFS,
> since bcache's primary raison d'etre is precisely to cache seeky stuff
> like metadata. :(
> 
Hi Nix,

Could you please to try whether the attached patch makes things better ?

Thanks in advance for your help.

-- 

Coly Li

--------------0BFDCE4D32CD1F8FB50BD466
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="0001-bcache-use-REQ_META-REQ_PRIO-to-indicate-bio-for-met.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="0001-bcache-use-REQ_META-REQ_PRIO-to-indicate-bio-for-met.pa";
 filename*1="tch"

RnJvbSA3YzI3ZTI2MDE3ZjYyOTdhNmJjNmE4MDc1NzMyZjY5ZDNlZGNjNTJlIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
VGh1LCA3IEZlYiAyMDE5IDE1OjU0OjI0ICswODAwClN1YmplY3Q6IFtQQVRDSF0gYmNhY2hl
OiB1c2UgKFJFUV9NRVRBfFJFUV9QUklPKSB0byBpbmRpY2F0ZSBiaW8gZm9yIG1ldGFkYXRh
CgpJbiAnY29tbWl0IDc1MmY2NmE3NWFiYSAoImJjYWNoZTogdXNlIFJFUV9QUklPIHRvIGlu
ZGljYXRlIGJpbyBmb3IKbWV0YWRhdGEiKScgUkVRX01FVEEgaXMgcmVwbGFjZWQgYnkgUkVR
X1BSSU8gdG8gaW5kaWNhdGUgbWV0YWRhdGEgYmlvLgpUaGlzIGFzc3VtcHRpb24gaXMgbm90
IGFsd2F5cyBjb3JyZWN0LCBlLmcuIFhGUyB1c2VzIFJFUV9NRVRBIHRvIG1hcmsKbWV0YWRh
dGEgYmlvIG90aGVyIHRoYW4gUkVRX1BSSU8uIFRoaXMgaXMgd2h5IE5peCByZXBvcnRzIGEg
cmVncmVzc2lvbgp0aGF0IGJjYWNoZSBkb2VzIG5vdCBjYWNoZSBtZXRhZGF0YSBmb3IgWEZT
IGFmdGVyIHRoZSBhYm92ZSBjb21taXQuCgpUaGFua3MgdG8gRGF2ZSBDaGlubmVyLCBoZSBl
eHBsYWlucyB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuIFJFUV9NRVRBIGFuZApSRVFfUFJJTyBm
cm9tIHZpZXcgb2YgZmlsZSBzeXN0ZW0gZGV2ZWxvcGVyLiBIZXJlIEkgcXVvdGUgcGFydCBv
ZiBoaXMKZXhwbGFuYXRpb24gZnJvbSBtYWlsaW5nIGxpc3QsCiAgIFJFUV9NRVRBIGlzIHVz
ZWQgZm9yIG1ldGFkYXRhLiBSRVFfUFJJTyBpcyB1c2VkIHRvIGNvbW11bmljYXRlIHRvCiAg
IHRoZSBsb3dlciBsYXllcnMgdGhhdCB0aGUgc3VibWl0dGVyIGNvbnNpZGVycyB0aGlzIElP
IHRvIGJlIG1vcmUKICAgaW1wb3J0YW50IHRoYXQgbm9uIFJFUV9QUklPIElPIGFuZCBzbyBk
aXNwYXRjaCBzaG91bGQgYmUgZXhwZWRpdGVkLgoKICAgSU9XcywgaWYgdGhlIGZpbGVzeXN0
ZW0gY29uc2lkZXJzIG1ldGFkYXRhIElPIHRvIGJlIG1vcmUgaW1wb3J0YW50CiAgIHRoYXQg
dXNlciBkYXRhIElPLCB0aGVuIGl0IHdpbGwgdXNlIFJFUV9QUklPIHwgUkVRX01FVEEgcmF0
aGVyIHRoYW4KICAganVzdCBSRVFfTUVUQS4KClRoZW4gaXQgc2VlbXMgYmlvcyB3aXRoIFJF
UV9NRVRBIG9yIFJFUV9QUklPIHNob3VsZCBib3RoIGJlIGNhY2hlZCBmb3IKcGVyZm9ybWFu
Y2Ugb3B0aW1hdGlvbiwgYmVjYXVzZSB0aGV5IGFyZSBhbGwgcHJvYmFibHkgbG93IEkvTyBs
YXRlbmN5CmRlbWFuZCBieSB1cHBlciBsYXllciAoZS5nLiBmaWxlIHN5c3RlbSkuCgpTbyBp
biB0aGlzIHBhdGNoLCB3aGVuIHdlIHdhbnQgdG8gY2hlY2sgd2hldGhlciBhIGJpbyBpcyBt
ZXRhZGF0YQpyZWxhdGVkLCBSRVFfTUVUQSBhbmQgUkVRX1BSSU8gYXJlIGJvdGggY2hlY2tl
ZC4gVGhlbiBib3RoIG1ldGFkYXRhIGFuZApoaWdoIHByaW9yaXR5IEkvTyByZXF1ZXN0cyB3
aWxsIGJlIGhhbmRsZWQgcHJvcGVybHkuCgpSZXBvcnRlZC1ieTogTml4IDxuaXhAZXNwZXJp
Lm9yZy51az4KU2lnbmVkLW9mZi1ieTogQ29seSBMaSA8Y29seWxpQHN1c2UuZGU+CkNjOiBE
YXZlIENoaW5uZXIgPGRhdmlkQGZyb21vcmJpdC5jb20+CkNjOiBBbmRyZSBOb2xsIDxtYWFu
QHR1ZWJpbmdlbi5tcGcuZGU+CkNjOiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4K
LS0tCiBkcml2ZXJzL21kL2JjYWNoZS9yZXF1ZXN0LmMgfCA0ICsrLS0KIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9tZC9iY2FjaGUvcmVxdWVzdC5jIGIvZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5j
CmluZGV4IDNiZjM1OTE0YmI1Ny4uNjJiZGE5MGEzOGRjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L21kL2JjYWNoZS9yZXF1ZXN0LmMKKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5j
CkBAIC0zOTUsNyArMzk1LDcgQEAgc3RhdGljIGJvb2wgY2hlY2tfc2hvdWxkX2J5cGFzcyhz
dHJ1Y3QgY2FjaGVkX2RldiAqZGMsIHN0cnVjdCBiaW8gKmJpbykKIAkgKiB1bmxlc3MgdGhl
IHJlYWQtYWhlYWQgcmVxdWVzdCBpcyBmb3IgbWV0YWRhdGEgKGVnLCBmb3IgZ2ZzMiBvciB4
ZnMpLgogCSAqLwogCWlmIChiaW8tPmJpX29wZiAmIChSRVFfUkFIRUFEfFJFUV9CQUNLR1JP
VU5EKSAmJgotCSAgICAhKGJpby0+Ymlfb3BmICYgUkVRX1BSSU8pKQorCSAgICAhKGJpby0+
Ymlfb3BmICYgKFJFUV9NRVRBfFJFUV9QUklPKSkpCiAJCWdvdG8gc2tpcDsKIAogCWlmIChi
aW8tPmJpX2l0ZXIuYmlfc2VjdG9yICYgKGMtPnNiLmJsb2NrX3NpemUgLSAxKSB8fApAQCAt
ODc3LDcgKzg3Nyw3IEBAIHN0YXRpYyBpbnQgY2FjaGVkX2Rldl9jYWNoZV9taXNzKHN0cnVj
dCBidHJlZSAqYiwgc3RydWN0IHNlYXJjaCAqcywKIAl9CiAKIAlpZiAoIShiaW8tPmJpX29w
ZiAmIFJFUV9SQUhFQUQpICYmCi0JICAgICEoYmlvLT5iaV9vcGYgJiBSRVFfUFJJTykgJiYK
KwkgICAgIShiaW8tPmJpX29wZiAmIChSRVFfTUVUQXxSRVFfUFJJTykpICYmCiAJICAgIHMt
PmlvcC5jLT5nY19zdGF0cy5pbl91c2UgPCBDVVRPRkZfQ0FDSEVfUkVBREEpCiAJCXJlYWRh
ID0gbWluX3Qoc2VjdG9yX3QsIGRjLT5yZWFkYWhlYWQgPj4gOSwKIAkJCSAgICAgIGdldF9j
YXBhY2l0eShiaW8tPmJpX2Rpc2spIC0gYmlvX2VuZF9zZWN0b3IoYmlvKSk7Ci0tIAoyLjE2
LjQKCg==
--------------0BFDCE4D32CD1F8FB50BD466--
