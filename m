Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F2457F3F
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 02:31:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6D8388F8054
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 00:31:49 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id cDExp2cM5XcydnYH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 00:31:47 -0700 (PDT)
Received: from zmail24.collab.prod.int.phx2.redhat.com
	(zmail24.collab.prod.int.phx2.redhat.com [10.5.83.30])
	by mx4-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s9A7VkUk020680
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 03:31:46 -0400
Date: Fri, 10 Oct 2014 03:31:46 -0400 (EDT)
From: Xu Wang <xuw@redhat.com>
Message-ID: <2090211370.42327532.1412926306812.JavaMail.zimbra@redhat.com>
In-Reply-To: <929991500.42327290.1412926226461.JavaMail.zimbra@redhat.com>
Subject: [PATCH] xfs: lock for removing item from cil->xc_cil in xlog_cil_push
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

RnJvbSA1OWM2YmFiYWI3YzRjZTg3MDgwMzYwMTgxNDNkMmFjYzE0NzdjYzdmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBHZW9yZ2UgV2FuZyA8eHV3QHJlZGhhdC5jb20+CkRhdGU6IEZy
aSwgMTAgT2N0IDIwMTQgMTU6MDI6MTQgKzA4MDAKU3ViamVjdDogW1BBVENIXSBbUEFUQ0hdIHhm
czogbG9jayBmb3IgcmVtb3ZpbmcgaXRlbSBmcm9tIGNpbC0+eGNfY2lsIGluCiB4bG9nX2NpbF9w
dXNoCgpUaGVyZSBpcyBhIHJhY2UgY29uZGl0aW9uIHdoZW4geGxvZ19jaWxfZm9yY2VfbHNuIGFu
ZCB4bG9nX2NpbF9wdXNoIGZvcgpjaWwtPnhjX2NpbCBpdGVtcy4gV2hlbiBmdW5jdGlvbiB4bG9n
X2NpbF9wdXNoX25vdyBjYWxsZWQgaW4KeGxvZ19jaWxfZm9yY2VfbHNuLCBhbmQgdGhlIHhsb2df
Y2lsX3B1c2ggcnVuIGluIHdvcmtxdWV1ZSBqdXN0IHJlYWNoZXMgdGhlIHBvaW50IGZvcgpzZXR0
aW5nIGNpbC0+eGNfY3VycmVudF9zZXF1ZW5jZSwgdGhlIHhsb2dfY2lsX2ZvcmNlX2xzbiBnb3Qg
dGhlIGxvY2sKYW5kIGNoZWNrIHRoZSAic2VxdWVuY2UgPT0gY2lsLT54Y19jdXJyZW50X3NlcXVl
bmNlICYmCiFsaXN0X2VtcHR5KCZjaWwtPnhjX2NpbCkiIGZvciByZXN0YXJ0LiBUaGUgc3RhdGVt
ZW50ICJzZXF1ZW5jZSA9PQpjaWwtPnhjX2N1cnJlbnRfc2VxdWVuY2UiIGlzIHRydWUsIGJ1dCB0
aGUgY2lsLT54Y19jaWwgaXMgZW1wdHkKYWNjb3JkaW5nIHRvIHRoZSB4bG9nX2NpbF9wdXNoIHJl
bW92ZWQgdGhlIGl0ZW1zIGluIGNpbC0+eGNfY2lsIHdpdGhvdXQKbG9jayBwcm90ZWN0aW9ubC4g
U28gdGhlIGZ1bmN0aW9uIHhsb2dfY2lsX2ZvcmNlX2xzbiB3aWxsIHJldHVybgpOVUxMQ09NTUlU
TFNOLCB3aGljaCBtZWFucyB0aGUgY2lsIGxvZyBmb3IgY3VycmVudCBzZXF1ZW5jZSB3aWxsIG5v
dCBiZQpzdWJtaXR0ZWQgdG8gZGlzay4gQW5kIGlmIHRoZXJlIGlzIG5vIG1vcmUgb3BlcmF0aW9u
cyhmb3IgZXhhbXBsZSwgd2hlbgp1bm1vdW50IGZzLCB0aGlzIHNpdHVhdGlvbiBoYXBwZW5lZCBp
bgp4ZnNfdW5tb3VudGZzLT54ZnNfbG9nX3NiY291bnQtPnhmc190cmFuc19jb21taXQpLCB0aGUg
eGZzIHdpbGwgaGFuZyB1cC4KClNpZ25lZC1vZmYtYnk6IEdlb3JnZSBXYW5nIDx4dXdAcmVkaGF0
LmNvbT4KLS0tCiBmcy94ZnMveGZzX2xvZ19jaWwuYyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMveGZzL3hmc19s
b2dfY2lsLmMgYi9mcy94ZnMveGZzX2xvZ19jaWwuYwppbmRleCBmNmI3OWU1Li45N2JhNTI3IDEw
MDY0NAotLS0gYS9mcy94ZnMveGZzX2xvZ19jaWwuYworKysgYi9mcy94ZnMveGZzX2xvZ19jaWwu
YwpAQCAtNDc4LDYgKzQ3OCw4IEBAIHhsb2dfY2lsX3B1c2goCiAgICAgKi8KICAgIGx2ID0gTlVM
TDsKICAgIG51bV9pb3ZlY3MgPSAwOworCisgICBzcGluX2xvY2soJmNpbC0+eGNfcHVzaF9sb2Nr
KTsKICAgIHdoaWxlICghbGlzdF9lbXB0eSgmY2lsLT54Y19jaWwpKSB7CiAgICAgICAgc3RydWN0
IHhmc19sb2dfaXRlbSAqaXRlbTsKCkBAIC01MzAsNyArNTMyLDYgQEAgeGxvZ19jaWxfcHVzaCgK
ICAgICAqIGFnYWluc3QgdGhlIGN1cnJlbnQgc2VxdWVuY2UgaW4gbG9nIGZvcmNlcyB3aXRob3V0
IHJpc2tpbmcKICAgICAqIGRlZmVyZW5jaW5nIGEgZnJlZWQgY29udGV4dCBwb2ludGVyLgogICAg
ICovCi0gICBzcGluX2xvY2soJmNpbC0+eGNfcHVzaF9sb2NrKTsKICAgIGNpbC0+eGNfY3VycmVu
dF9zZXF1ZW5jZSA9IG5ld19jdHgtPnNlcXVlbmNlOwogICAgbGlzdF9hZGQoJmN0eC0+Y29tbWl0
dGluZywgJmNpbC0+eGNfY29tbWl0dGluZyk7CiAgICBzcGluX3VubG9jaygmY2lsLT54Y19wdXNo
X2xvY2spOwotLSAKMS45LjMKCgotLSAKR2VvcmdlIFdhbmcg546L5petCgpLZXJuZWwgUXVhbnRp
dHkgRW5naW5lZXIKUmVkIEhhdCBTb2Z0d2FyZSAoQmVpamluZykgQ28uLEx0ZApJUkM6eHV3ClRl
bDorODYtMDEwLTYyNjA4MDQxClBob25lOjE1OTAxMjMxNTc5CjkvRiwgVG93ZXIgQywgUmF5Y29t
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFp
bGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0
aW5mby94ZnMK
