Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F4E47F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 07:27:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 431F1304053
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 05:27:56 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id eHWzbzvTl08hnLd3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 05:27:55 -0800 (PST)
Message-ID: <52D3E9D6.2030104@oracle.com>
Date: Mon, 13 Jan 2014 21:27:50 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfstests: make btrfs/001.out in line with subvol
	delete output
References: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
	<5A6081D2-68E6-47BC-A534-6502B680DDDD@gmail.com>
In-Reply-To: <5A6081D2-68E6-47BC-A534-6502B680DDDD@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

CkhpIFdhbmcsCgogQWggeWVzLiB3aHkgZGlkIEkgbWlzcyB0aGF0IHBvaW50IGVhcmxpZXIuCiBX
aWxsIGZpeCBpdC4KClRoYW5rcywgQW5hbmQKCgpPbiAxMy8wMS8yMDE0IDIxOjE0LCBXYW5nIFNo
aWxvbmcgd3JvdGU6Cj4gSGVsbG8gQW5hbmQsCj4gCj4gSSB3YXMgbm90aWNpbmcgdGhpcyBwcm9i
bGVtIHdoZW4gdXNpbmcgdGhlIGxhdGVzdCBidHJmcy1wcm9ncyB0byB0ZXN0IF5fXgo+IAo+IEkg
dGhpbmsgYSBiZXR0ZXIgd2F5IGlzIHRvIGZpbHRlciBtZXNzYWdlICdUcmFuc2FjdGlvbiBjb21t
aXQ6IG5vbmUgKGRlZmF1bHQpJwo+IFJhdGhlciB0aGFuIGFkZCBpdCwgb3RoZXJ3aXNlLCBwZW9w
bGUgd2lsbCBmYWlsIHRoaXMgdGVzdCBpZiB0aGV5IHVzZSBwcmV2aW91cwo+IGJ0cmZzLXByb2dz
oa2hrQo+IAo+IFRoYW5rcywKPiBXYW5nCj4+IEZyb206IEFuYW5kIEphaW4gPEFuYW5kLkphaW5A
b3JhY2xlLmNvbT4KPj4KPj4gYnRyZnMvMDAxIGlzIGZhaWxpbmcgYXMgYmVsb3cgYnRyZnMtcHJv
Z3MgcGF0Y2ggY2hhbmdlZCB0aGUKPj4gb3V0cHV0IGR1cmluZyBzdWJ2b2wgZGVsZXRlLgo+PiBQ
YXRjaCA6Cj4+IGJ0cmZzLXByb2dzOiBhZGQgb3B0aW9ucyB0byBzZXQgY29tbWl0IG1vZGUgYWZ0
ZXIgc3Vidm9sIGRlbGV0ZQo+Pgo+PiBzbyBhZGQgaXQgdG8gdGhlIGJ0cmZzLzAwMS5vdXQKPj4K
Pj4gU2lnbmVkLW9mZi1ieTogQW5hbmQgSmFpbiA8QW5hbmQuSmFpbkBvcmFjbGUuY29tPgo+PiAt
LS0KPj4gdGVzdHMvYnRyZnMvMDAxLm91dCB8IDEgKwo+PiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKykKPj4KPj4gZGlmZiAtLWdpdCBhL3Rlc3RzL2J0cmZzLzAwMS5vdXQgYi90ZXN0cy9i
dHJmcy8wMDEub3V0Cj4+IGluZGV4IGM3ODJiZGUuLmEyNTU2MTQgMTAwNjQ0Cj4+IC0tLSBhL3Rl
c3RzL2J0cmZzLzAwMS5vdXQKPj4gKysrIGIvdGVzdHMvYnRyZnMvMDAxLm91dAo+PiBAQCAtMzMs
NiArMzMsNyBAQCBzdWJ2b2wKPj4gTGlzdGluZyBzdWJ2b2x1bWVzCj4+IHNuYXAKPj4gc3Vidm9s
Cj4+ICtUcmFuc2FjdGlvbiBjb21taXQ6IG5vbmUgKGRlZmF1bHQpCj4+IERlbGV0ZSBzdWJ2b2x1
bWUgJ1NDUkFUQ0hfTU5UL3NuYXAnCj4+IExpc3Qgcm9vdCBkaXIKPj4gc3Vidm9sCj4+IC0tIAo+
PiAxLjguNC4yCj4+Cj4+IC0tCj4+IFRvIHVuc3Vic2NyaWJlIGZyb20gdGhpcyBsaXN0OiBzZW5k
IHRoZSBsaW5lICJ1bnN1YnNjcmliZSBsaW51eC1idHJmcyIgaW4KPj4gdGhlIGJvZHkgb2YgYSBt
ZXNzYWdlIHRvIG1ham9yZG9tb0B2Z2VyLmtlcm5lbC5vcmcKPj4gTW9yZSBtYWpvcmRvbW8gaW5m
byBhdCAgaHR0cDovL3ZnZXIua2VybmVsLm9yZy9tYWpvcmRvbW8taW5mby5odG1sCj4gCj4gLS0K
PiBUbyB1bnN1YnNjcmliZSBmcm9tIHRoaXMgbGlzdDogc2VuZCB0aGUgbGluZSAidW5zdWJzY3Jp
YmUgbGludXgtYnRyZnMiIGluCj4gdGhlIGJvZHkgb2YgYSBtZXNzYWdlIHRvIG1ham9yZG9tb0B2
Z2VyLmtlcm5lbC5vcmcKPiBNb3JlIG1ham9yZG9tbyBpbmZvIGF0ICBodHRwOi8vdmdlci5rZXJu
ZWwub3JnL21ham9yZG9tby1pbmZvLmh0bWwKPiAKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0
dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
