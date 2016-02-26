Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 66BC37CA1
	for <xfs@oss.sgi.com>; Fri, 26 Feb 2016 00:38:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE66DAC001
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2016 22:38:00 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id 6l1Z4FqJIPh1YW7u (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Feb 2016 22:37:58 -0800 (PST)
Date: Fri, 26 Feb 2016 01:37:57 -0500 (EST)
From: Prasanna Kumar Kalever <pkalever@redhat.com>
Message-ID: <957291997.53773945.1456468677495.JavaMail.zimbra@redhat.com>
In-Reply-To: <1112951359.53758727.1456466113255.JavaMail.zimbra@redhat.com>
Subject: How to copy files with preserving reflinks ?
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
Cc: Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>

SGksCgpJIGhhdmUgYSBWTSBmaWxlIHdpdGggcmVmbGlua3MgdG8gaXQsIHRoZSByZWZsaW5rcyB3
ZXJlIHRha2VuIGV2ZXJ5IG5pZ2h0LgoKTXkgcXVlc3Rpb24gaXMgaG93IHRvIGNvcHkvbWlncmF0
ZSBhbGwgdGhlc2UgZmlsZSB0byBhIGRpZmZlcmVudCB4ZnMgcGFydGl0aW9uICh3aGljaCBhbHNv
IGhhdmUgcmVmbGluayBlbmFibGVkKSB3aXRob3V0IGxvb3NpbmcgdGhlIHJlZmxpbmtzIHByb3Bl
cnR5LCBlbHNlIG1heSBsZWFkIHRvIGNvcHkgYWxsIHRoZSBzaGFyZWQgYmxvY2tzIHBlciBmaWxl
IHdoaWNoIHdpbGwgY29zdCBsYXJnZSBkaXNrIHNwYWNlLgoKSSBoYXZlIHRyaWVkIHRvIGNvcHkg
dGhlbSB1c2luZyByc3luYyBhcyBiZWxvdzoKCk9uIFBhcnRpdGlvbiAxOgoKQWN0dWFsRmlsZS5p
bWcgLS0gWzFdIEFjdGF1bCBTaXplIDEwR0IgKyBbMl0gQXBwZW5kIDJHQiArIFszXSBBcHBlbmQg
MUdCClJlZmxpbmtDb3B5MSAgIC0tIFsxXSBBY3R1YWwgU2l6ZSAgMCAgLS0gU2hhcmVkIGJsb2Nr
cyAxMEdCClJlZmxpbmtDb3B5MiAgIC0tIFsyXSBBY3R1YWwgU2l6ZSAgMCAgLS0gU2hhcmVkIGJs
b2NrcyAxMkdCCgoKSSBoYXZlIGZpcnN0IHJzeW5jIHRoZSBmaWxlcyBpbnRvIFBhcnRpdGlvbiAy
IGFzIGJlbG93OgoKIyBjZCBQQVJUSVRJT04yCgojIHJzeW5jIC9QQVJUSVRJT04xL1JlZmxpbmtD
b3B5MSBBY3R1YWxGaWxlLmltZwojIGR1IC1zaCBBY3R1YWxGaWxlLmltZwoxMEdCCiMgY3AgLS1y
ZWZsaW5rPWFsd2F5cyBBY3R1YWxGaWxlLmltZwoKIyByc3luYyAvUEFSVElUSU9OMS9SZWZsaW5r
Q29weTIgQWN0dWFsRmlsZS5pbWcKIyBkdSAtc2ggQWN0dWFsRmlsZS5pbWcKMTJHQgojIGNwIC0t
cmVmbGluaz1hbHdheXMgQWN0dWFsRmlsZS5pbWcKCiMgcnN5bmMgIC9QQVJUSVRJT04xL0FjdHVh
bEZpbGUuaW1nIEFjdHVhbEZpbGUuaW1nCgpCdXQgdGhlIHNpemUgdXNlZCBieSBwYXJ0aXRpb24g
d2FzIDM1R0IgKHZlcmlmaWVkIHVzaW5nIGRmIC1oKSBpbnN0ZWFkIG9mIDEzR0IgCgoKCkFsc28s
IHdoZXJlIGNhbiBJIGZpbmQgcmVmbGluayByZWxhdGVkIHRvb2xzID8KCgpUaGFua3MsCi1QcmFz
YW5uYSDigIsgCgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21h
aWxtYW4vbGlzdGluZm8veGZzCg==
