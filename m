Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 34E297F50
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 10:04:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 231B58F8059
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 08:04:05 -0700 (PDT)
Received: from mail.rvx.is (mail.rvx.is [178.19.51.189]) by cuda.sgi.com with
	ESMTP id RnQ1LcyUEeP3p33E (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2015 08:04:03 -0700 (PDT)
Date: Wed, 11 Mar 2015 15:04:02 +0000 (GMT)
From: Rui Gomes <rgomes@rvx.is>
Message-ID: <1908077521.428877.1426086242030.JavaMail.zimbra@rvx.is>
In-Reply-To: <550054D9.3010602@sandeen.net>
References: <54FDFEDC.5090106@sandeen.net>
	<1061986380.422955.1426008424991.JavaMail.zimbra@rvx.is>
	<54FF2BBF.7060404@sandeen.net>
	<410959445.428221.1426083973347.JavaMail.zimbra@rvx.is>
	<550054D9.3010602@sandeen.net>
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_428875_1857892055.1426086242028"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: omar <omar@rvx.is>, xfs <xfs@oss.sgi.com>

------=_Part_428875_1857892055.1426086242028
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello Eric, 

After applying that patch I get yet another Segmentation Fault in a different place, gdb bt and output in the attachment.


Just in case this help, bellow the inode right before the segmentation fault:

xfs_db -c "inode 620507648" -c "p" /dev/sdb1 
Metadata corruption detected at block 0x4ffed6d08/0x1000
xfs_db: cannot init perag data (117). Continuing anyway.
core.magic = 0x494e
core.mode = 040755
core.version = 2
core.format = 2 (extents)
core.nlinkv2 = 3
core.onlink = 0
core.projid_lo = 0
core.projid_hi = 0
core.uid = 0
core.gid = 0
core.flushiter = 2
core.atime.sec = Fri May 16 12:21:52 2014
core.atime.nsec = 779442171
core.mtime.sec = Tue Mar 24 12:03:59 2009
core.mtime.nsec = 000000000
core.ctime.sec = Fri Feb 28 19:54:03 2014
core.ctime.nsec = 736630717
core.size = 4096
core.nblocks = 1
core.extsize = 0
core.nextents = 1
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 3064228498
next_unlinked = null
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,38781727,1,0]




Regards 

------------------------------- 
Rui Gomes 
CTO 


RVX - Reykjavik Visual Effects 
Seljavegur 2, 
101 Reykjavik 
Iceland 


Tel: + 354 527 3330 
Mob: + 354 663 3360

----- Original Message -----
From: "Eric Sandeen" <sandeen@sandeen.net>
To: "Rui Gomes" <rgomes@rvx.is>
Cc: "omar" <omar@rvx.is>, "xfs" <xfs@oss.sgi.com>
Sent: Wednesday, 11 March, 2015 14:44:41
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts beyond dir size

On 3/11/15 10:26 AM, Rui Gomes wrote:
> Hello Eric,
> 
> Thank you for the quick reply yesterday, I got to try the new patched version today,
> and we have now a segmentation fault at a different stage of the repair  \o/ 
> Full output plus gdb traceback in the attachment.

If you have 4k sectors, you might need this patch from the list:

[PATCH] xfs: superblock buffers need to be sector sized

http://marc.info/?l=linux-xfs&m=142476196802097&w=2

as it's not merged yet.

-Eric
------=_Part_428875_1857892055.1426086242028
Content-Type: text/plain; name=xfs_gdb_2.txt
Content-Disposition: attachment; filename=xfs_gdb_2.txt
Content-Transfer-Encoding: base64

VFJVQ0FURUQ6CgppbWFwIGNsYWltcyBhIGZyZWUgaW5vZGUgNjIwMzM0NzE3IGlzIGluIHVzZSwg
Y29ycmVjdGluZyBpbWFwIGFuZCBjbGVhcmluZyBpbm9kZQpjbGVhcmVkIGlub2RlIDYyMDMzNDcx
NwppbWFwIGNsYWltcyBhIGZyZWUgaW5vZGUgNjIwMzM0NzE4IGlzIGluIHVzZSwgY29ycmVjdGlu
ZyBpbWFwIGFuZCBjbGVhcmluZyBpbm9kZQpjbGVhcmVkIGlub2RlIDYyMDMzNDcxOApiYWQgaW5v
ZGUgZm9ybWF0IGluIGlub2RlIDYyMDMzNDcxOQpjbGVhcmVkIGlub2RlIDYyMDMzNDcxOQpNZXRh
ZGF0YSBjb3JydXB0aW9uIGRldGVjdGVkIGF0IGJsb2NrIDB4MTI3ZTE4ZjgvMHgxMDAwCmJhZCBk
aXJlY3RvcnkgYmxvY2sgbWFnaWMgIyAweDQxNGYwNzQ5IGluIGJsb2NrIDAgZm9yIGRpcmVjdG9y
eSBpbm9kZSA2MjA1MDc2NDgKY29ycnVwdCBibG9jayAwIGluIGRpcmVjdG9yeSBpbm9kZSA2MjA1
MDc2NDgKICAgICAgICB3aWxsIGp1bmsgYmxvY2sKbm8gLiBlbnRyeSBmb3IgZGlyZWN0b3J5IDYy
MDUwNzY0OApubyAuLiBlbnRyeSBmb3IgZGlyZWN0b3J5IDYyMDUwNzY0OApwcm9ibGVtIHdpdGgg
ZGlyZWN0b3J5IGNvbnRlbnRzIGluIGlub2RlIDYyMDUwNzY0OApjbGVhcmVkIGlub2RlIDYyMDUw
NzY0OAoKUHJvZ3JhbSByZWNlaXZlZCBzaWduYWwgU0lHU0VHViwgU2VnbWVudGF0aW9uIGZhdWx0
LgoweDAwMDAwMDAwMDA0NGRiY2QgaW4gX194ZnNfZGlyM19kYXRhX2NoZWNrIChkcD1kcEBlbnRy
eT0weDAsIGJwPWJwQGVudHJ5PTB4MTUzOGU4MTApIGF0IHhmc19kaXIyX2RhdGEuYzoxNDgKMTQ4
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb3IgKGkgPSAwOyBpIDwgYmUzMl90b19jcHUo
YnRwLT5jb3VudCk7IGkrKykgewooZ2RiKSBidAojMCAgMHgwMDAwMDAwMDAwNDRkYmNkIGluIF9f
eGZzX2RpcjNfZGF0YV9jaGVjayAoZHA9ZHBAZW50cnk9MHgwLCBicD1icEBlbnRyeT0weDE1Mzhl
ODEwKSBhdCB4ZnNfZGlyMl9kYXRhLmM6MTQ4CiMxICAweDAwMDAwMDAwMDA0NGI5ZWEgaW4geGZz
X2RpcjNfYmxvY2tfdmVyaWZ5IChicD1icEBlbnRyeT0weDE1MzhlODEwKSBhdCB4ZnNfZGlyMl9i
bG9jay5jOjYyCiMyICAweDAwMDAwMDAwMDA0NGJiMDcgaW4geGZzX2RpcjNfYmxvY2tfcmVhZF92
ZXJpZnkgKGJwPTB4MTUzOGU4MTApIGF0IHhmc19kaXIyX2Jsb2NrLmM6NzYKIzMgIDB4MDAwMDAw
MDAwMDQyZmQ4MyBpbiBsaWJ4ZnNfcmVhZGJ1Zl92ZXJpZnkgKG9wcz0weDQ2ZjU1MCA8eGZzX2Rp
cjNfYmxvY2tfYnVmX29wcz4sIGJwPTB4MTUzOGU4MTApIGF0IHJkd3IuYzo3NTYKIzQgIGxpYnhm
c19yZWFkYnVmIChidHA9MHg2OTVhZjAsIGJsa25vPTMxMDI1MzgwOCwgbGVuPTgsIGZsYWdzPTAs
IG9wcz0weDQ2ZjU1MCA8eGZzX2RpcjNfYmxvY2tfYnVmX29wcz4pIGF0IHJkd3IuYzo4MDIKIzUg
IDB4MDAwMDAwMDAwMDQyZmY0NSBpbiBsaWJ4ZnNfcmVhZGJ1Zl9tYXAgKGJ0cD08b3B0aW1pemVk
IG91dD4sIG1hcD1tYXBAZW50cnk9MHg3ZmZmZmZmZmQ3NzAsIG5tYXBzPW5tYXBzQGVudHJ5PTEs
IGZsYWdzPWZsYWdzQGVudHJ5PTAsIG9wcz08b3B0aW1pemVkIG91dD4pIGF0IHJkd3IuYzo4NDYK
IzYgIDB4MDAwMDAwMDAwMDQxMTg4NSBpbiBkYV9yZWFkX2J1ZiAobXA9bXBAZW50cnk9MHg3ZmZm
ZmZmZmRmZDAsIG5leD0xLCBibXA9PG9wdGltaXplZCBvdXQ+LCBvcHM9PG9wdGltaXplZCBvdXQ+
KSBhdCBkaXIyLmM6MTIyCiM3ICAweDAwMDAwMDAwMDA0MTMxZDAgaW4gcHJvY2Vzc19ibG9ja19k
aXIyIChkaXA9MHgxNTM4ZWQwMCwgZGlub19kaXJ0eT0weDdmZmZmZmZmZGMwMCwgZGlybmFtZT0w
eDQ2ODczMiAiIiwgcmVwYWlyPTxzeW50aGV0aWMgcG9pbnRlcj4sIGRvdGRvdD0weDdmZmZmZmZm
ZDg2NCwgZG90PTB4N2ZmZmZmZmZkODYwLCBibGttYXA9MHg2OTM4YzAsIHBhcmVudD0weDdmZmZm
ZmZmZGMwOCwgCiAgICBpbm9fZGlzY292ZXJ5PTEsIGlubz02MjA1MDc2NTEsIG1wPTB4N2ZmZmZm
ZmZkZmQwKSBhdCBkaXIyLmM6MTYwNgojOCAgcHJvY2Vzc19kaXIyIChtcD1tcEBlbnRyeT0weDdm
ZmZmZmZmZGZkMCwgaW5vPWlub0BlbnRyeT02MjA1MDc2NTEsIGRpcD1kaXBAZW50cnk9MHgxNTM4
ZWQwMCwgaW5vX2Rpc2NvdmVyeT1pbm9fZGlzY292ZXJ5QGVudHJ5PTEsIGRpbm9fZGlydHk9ZGlu
b19kaXJ0eUBlbnRyeT0weDdmZmZmZmZmZGMwMCwgZGlybmFtZT1kaXJuYW1lQGVudHJ5PTB4NDY4
NzMyICIiLCAKICAgIHBhcmVudD1wYXJlbnRAZW50cnk9MHg3ZmZmZmZmZmRjMDgsIGJsa21hcD0w
eDY5MzhjMCkgYXQgZGlyMi5jOjIwMTgKIzkgIDB4MDAwMDAwMDAwMDQxMTJhNCBpbiBwcm9jZXNz
X2Rpbm9kZV9pbnQgKG1wPW1wQGVudHJ5PTB4N2ZmZmZmZmZkZmQwLCBkaW5vPWRpbm9AZW50cnk9
MHgxNTM4ZWQwMCwgYWdubz1hZ25vQGVudHJ5PTAsIGlubz1pbm9AZW50cnk9NjIwNTA3NjUxLCB3
YXNfZnJlZT08b3B0aW1pemVkIG91dD4sIGRpcnR5PWRpcnR5QGVudHJ5PTB4N2ZmZmZmZmZkYzAw
LCAKICAgIHVzZWQ9dXNlZEBlbnRyeT0weDdmZmZmZmZmZGJmYywgdmVyaWZ5X21vZGU9dmVyaWZ5
X21vZGVAZW50cnk9MCwgdW5jZXJ0YWluPXVuY2VydGFpbkBlbnRyeT0wLCBpbm9fZGlzY292ZXJ5
PWlub19kaXNjb3ZlcnlAZW50cnk9MSwgY2hlY2tfZHVwcz1jaGVja19kdXBzQGVudHJ5PTAsIGV4
dHJhX2F0dHJfY2hlY2s9ZXh0cmFfYXR0cl9jaGVja0BlbnRyeT0xLCAKICAgIGlzYV9kaXI9aXNh
X2RpckBlbnRyeT0weDdmZmZmZmZmZGMwNCwgcGFyZW50PXBhcmVudEBlbnRyeT0weDdmZmZmZmZm
ZGMwOCkgYXQgZGlub2RlLmM6MjYyOQojMTAgMHgwMDAwMDAwMDAwNDExNmJlIGluIHByb2Nlc3Nf
ZGlub2RlIChtcD1tcEBlbnRyeT0weDdmZmZmZmZmZGZkMCwgZGlubz1kaW5vQGVudHJ5PTB4MTUz
OGVkMDAsIGFnbm89YWdub0BlbnRyeT0wLCBpbm89aW5vQGVudHJ5PTYyMDUwNzY1MSwgd2FzX2Zy
ZWU9PG9wdGltaXplZCBvdXQ+LCBkaXJ0eT1kaXJ0eUBlbnRyeT0weDdmZmZmZmZmZGMwMCwgdXNl
ZD11c2VkQGVudHJ5PTB4N2ZmZmZmZmZkYmZjLCAKICAgIGlub19kaXNjb3Zlcnk9aW5vX2Rpc2Nv
dmVyeUBlbnRyeT0xLCBjaGVja19kdXBzPWNoZWNrX2R1cHNAZW50cnk9MCwgZXh0cmFfYXR0cl9j
aGVjaz1leHRyYV9hdHRyX2NoZWNrQGVudHJ5PTEsIGlzYV9kaXI9aXNhX2RpckBlbnRyeT0weDdm
ZmZmZmZmZGMwNCwgcGFyZW50PXBhcmVudEBlbnRyeT0weDdmZmZmZmZmZGMwOCkgYXQgZGlub2Rl
LmM6MjczNwojMTEgMHgwMDAwMDAwMDAwNDBiNzdmIGluIHByb2Nlc3NfaW5vZGVfY2h1bmsgKG1w
PW1wQGVudHJ5PTB4N2ZmZmZmZmZkZmQwLCBhZ25vPWFnbm9AZW50cnk9MCwgZmlyc3RfaXJlYz1m
aXJzdF9pcmVjQGVudHJ5PTB4N2ZmZmQ4NzEyMTkwLCBpbm9fZGlzY292ZXJ5PWlub19kaXNjb3Zl
cnlAZW50cnk9MSwgY2hlY2tfZHVwcz1jaGVja19kdXBzQGVudHJ5PTAsIAogICAgZXh0cmFfYXR0
cl9jaGVjaz1leHRyYV9hdHRyX2NoZWNrQGVudHJ5PTEsIGJvZ3VzPWJvZ3VzQGVudHJ5PTB4N2Zm
ZmZmZmZkYzhjLCBudW1faW5vcz08b3B0aW1pemVkIG91dD4pIGF0IGRpbm9fY2h1bmtzLmM6Nzcy
CiMxMiAweDAwMDAwMDAwMDA0MGNiYWQgaW4gcHJvY2Vzc19hZ2lub2RlcyAobXA9MHg3ZmZmZmZm
ZmRmZDAsIHBmX2FyZ3M9cGZfYXJnc0BlbnRyeT0weDAsIGFnbm89YWdub0BlbnRyeT0wLCBpbm9f
ZGlzY292ZXJ5PWlub19kaXNjb3ZlcnlAZW50cnk9MSwgY2hlY2tfZHVwcz1jaGVja19kdXBzQGVu
dHJ5PTAsIGV4dHJhX2F0dHJfY2hlY2s9ZXh0cmFfYXR0cl9jaGVja0BlbnRyeT0xKQogICAgYXQg
ZGlub19jaHVua3MuYzoxMDI1CiMxMyAweDAwMDAwMDAwMDA0MTg2ZmUgaW4gcHJvY2Vzc19hZ19m
dW5jICh3cT0weDdmZmZmZmZmZGQ2MCwgYWdubz0wLCBhcmc9MHgwKSBhdCBwaGFzZTMuYzo3Nwoj
MTQgMHgwMDAwMDAwMDAwNDI1NmNhIGluIHByZWZldGNoX2FnX3JhbmdlICh3b3JrPTB4N2ZmZmZm
ZmZkZDYwLCBzdGFydF9hZz08b3B0aW1pemVkIG91dD4sIGVuZF9hZz0zMiwgZGlyc19vbmx5PWZh
bHNlLCBmdW5jPTB4NDE4NmIwIDxwcm9jZXNzX2FnX2Z1bmM+KSBhdCBwcmVmZXRjaC5jOjkwNgoj
MTUgMHgwMDAwMDAwMDAwNDI1ODJiIGluIGRvX2lub2RlX3ByZWZldGNoIChtcD1tcEBlbnRyeT0w
eDdmZmZmZmZmZGZkMCwgc3RyaWRlPTAsIGZ1bmM9ZnVuY0BlbnRyeT0weDQxODZiMCA8cHJvY2Vz
c19hZ19mdW5jPiwgY2hlY2tfY2FjaGU9Y2hlY2tfY2FjaGVAZW50cnk9ZmFsc2UsIGRpcnNfb25s
eT1kaXJzX29ubHlAZW50cnk9ZmFsc2UpIGF0IHByZWZldGNoLmM6OTY5CiMxNiAweDAwMDAwMDAw
MDA0MTg4MGQgaW4gcHJvY2Vzc19hZ3MgKG1wPTB4N2ZmZmZmZmZkZmQwKSBhdCBwaGFzZTMuYzo4
NQojMTcgcGhhc2UzIChtcD1tcEBlbnRyeT0weDdmZmZmZmZmZGZkMCkgYXQgcGhhc2UzLmM6MTIx
CiMxOCAweDAwMDAwMDAwMDA0MDM2NTYgaW4gbWFpbiAoYXJnYz08b3B0aW1pemVkIG91dD4sIGFy
Z3Y9PG9wdGltaXplZCBvdXQ+KSBhdCB4ZnNfcmVwYWlyLmM6Nzg5CihnZGIpIAo=
------=_Part_428875_1857892055.1426086242028
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_428875_1857892055.1426086242028--
