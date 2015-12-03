Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 76D1C7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 20:34:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE3FAAC006
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 18:34:02 -0800 (PST)
From: "zhao.mingyue@h3c.com" <zhao.mingyue@h3c.com>
Subject: xfs_growfs can expand capacity,then how to reduce xfs filesystem
	capacity?
Date: Thu, 3 Dec 2015 02:33:47 +0000
Message-ID: <1CB94550540AE44E9CAAE8CD5AF40BF846D19CCC@H3CMLB12-EX.srv.huawei-3com.com>
Content-Language: zh-CN
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: "xfs-request@oss.sgi.com" <xfs-request@oss.sgi.com>

aGksDQogIEkga25vdyB0aGF0IHhmc19ncm93ZnMgY2FuIGV4cGFuZCB4ZnMgY2FwYWNpdHksbm93
IEkgd2FudCB0byByZWR1Y2UgdGhlIGNhcGFjaXR5LGJ1dCBJIGRvbid0IGtub3cgdGhlIGNvbW1h
bmQuY2FuIHNvbWVvbmUgaGVscCBtZSA/DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQrmnKzpgq7ku7bl
j4rlhbbpmYTku7blkKvmnInmna3lt57ljY7kuInpgJrkv6HmioDmnK/mnInpmZDlhazlj7jnmoTk
v53lr4bkv6Hmga/vvIzku4XpmZDkuo7lj5HpgIHnu5nkuIrpnaLlnLDlnYDkuK3liJflh7oNCuea
hOS4quS6uuaIlue+pOe7hOOAguemgeatouS7u+S9leWFtuS7luS6uuS7peS7u+S9leW9ouW8j+S9
v+eUqO+8iOWMheaLrOS9huS4jemZkOS6juWFqOmDqOaIlumDqOWIhuWcsOazhOmcsuOAgeWkjeWI
tuOAgQ0K5oiW5pWj5Y+R77yJ5pys6YKu5Lu25Lit55qE5L+h5oGv44CC5aaC5p6c5oKo6ZSZ5pS2
5LqG5pys6YKu5Lu277yM6K+35oKo56uL5Y2z55S16K+d5oiW6YKu5Lu26YCa55+l5Y+R5Lu25Lq6
5bm25Yig6Zmk5pysDQrpgq7ku7bvvIENClRoaXMgZS1tYWlsIGFuZCBpdHMgYXR0YWNobWVudHMg
Y29udGFpbiBjb25maWRlbnRpYWwgaW5mb3JtYXRpb24gZnJvbSBIM0MsIHdoaWNoIGlzDQppbnRl
bmRlZCBvbmx5IGZvciB0aGUgcGVyc29uIG9yIGVudGl0eSB3aG9zZSBhZGRyZXNzIGlzIGxpc3Rl
ZCBhYm92ZS4gQW55IHVzZSBvZiB0aGUNCmluZm9ybWF0aW9uIGNvbnRhaW5lZCBoZXJlaW4gaW4g
YW55IHdheSAoaW5jbHVkaW5nLCBidXQgbm90IGxpbWl0ZWQgdG8sIHRvdGFsIG9yIHBhcnRpYWwN
CmRpc2Nsb3N1cmUsIHJlcHJvZHVjdGlvbiwgb3IgZGlzc2VtaW5hdGlvbikgYnkgcGVyc29ucyBv
dGhlciB0aGFuIHRoZSBpbnRlbmRlZA0KcmVjaXBpZW50KHMpIGlzIHByb2hpYml0ZWQuIElmIHlv
dSByZWNlaXZlIHRoaXMgZS1tYWlsIGluIGVycm9yLCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIN
CmJ5IHBob25lIG9yIGVtYWlsIGltbWVkaWF0ZWx5IGFuZCBkZWxldGUgaXQhDQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
