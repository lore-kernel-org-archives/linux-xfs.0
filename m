Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0E0077F51
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 11:33:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E15AA8F8035
	for <xfs@oss.sgi.com>; Mon, 12 Jan 2015 09:33:26 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [144.76.218.113]) by
	cuda.sgi.com with ESMTP id AKuW0phC65oKILXE for
	<xfs@oss.sgi.com>; Mon, 12 Jan 2015 09:33:10 -0800 (PST)
Message-ID: <54B40552.50106@aei.mpg.de>
Date: Mon, 12 Jan 2015 18:33:06 +0100
From: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: extremely slow file creation/deletion after xfs ran full
References: <54B387A1.6000807@aei.mpg.de> <54B3CC6A.4080405@aei.mpg.de>
	<20150112155206.GD25944@bfoster.bfoster>
	<54B3F19D.6030307@aei.mpg.de>
	<20150112163749.GE25944@bfoster.bfoster>
In-Reply-To: <20150112163749.GE25944@bfoster.bfoster>
Content-Type: multipart/mixed; boundary="------------020906040403040503030603"
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020906040403040503030603
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi

On 01/12/2015 05:37 PM, Brian Foster wrote:
> No, but it does show that there are a bunch of free inodes scattered
> throughout the existing records in most of the AGs. The finobt should
> definitely help avoid the allocation latency when this occurs.
> 

That is good to know/hope :)

> It is interesting that you have so many more free inodes in ag 0 (~53m
> as opposed to several hundreds/thousands in others). What does 'p count'
> show for each ag? Was this fs grown to the current size over time?
> 
"p count" seems to "thin out" over ag:

count = 513057792
count = 16596224
count = 15387584
count = 14958528
count = 4096960
count = 4340416
count = 4987968
count = 3321792
count = 5041856
count = 5485376
count = 5233088
count = 5810432
count = 5271552
count = 5464000
count = 365440

(if the full print output is interesting, it's attached).

The FS was never grown, the machine was installed on November 5th, 2012
and was (ab)using the FS ever since. On average there have been about
1-2 million file creations per day (ranging from a few kByte files to a
few 100 kBytes) and also an equally large number of deletions (after
some time). Thus overall, a somewhat busy server.

Cheers

Carsten


--------------020906040403040503030603
Content-Type: text/plain; charset=UTF-8;
 name="ag-print.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ag-print.log"

CkFHIDAKbWFnaWNudW0gPSAweDU4NDE0NzQ5CnZlcnNpb25udW0gPSAxCnNlcW5vID0gMAps
ZW5ndGggPSAyNjg0MzU0NTUKY291bnQgPSA1MTMwNTc3OTIKcm9vdCA9IDEyODYKbGV2ZWwg
PSAzCmZyZWVjb3VudCA9IDUzNzk1ODg0Cm5ld2lubyA9IDEyOApkaXJpbm8gPSBudWxsCnVu
bGlua2VkWzAtNjNdID0gCnV1aWQgPSAwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAw
MDAwMDAKbHNuID0gMApjcmMgPSAwICh1bmNoZWNrZWQpCmZyZWVfcm9vdCA9IDAKZnJlZV9s
ZXZlbCA9IDAKCkFHIDEKbWFnaWNudW0gPSAweDU4NDE0NzQ5CnZlcnNpb25udW0gPSAxCnNl
cW5vID0gMQpsZW5ndGggPSAyNjg0MzU0NTUKY291bnQgPSAxNjU5NjIyNApyb290ID0gMTIz
NjUzCmxldmVsID0gMwpmcmVlY291bnQgPSAyNTEKbmV3aW5vID0gMTc2OTYKZGlyaW5vID0g
bnVsbAp1bmxpbmtlZFswLTYzXSA9IAp1dWlkID0gMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAt
MDAwMDAwMDAwMDAwCmxzbiA9IDAKY3JjID0gMCAodW5jaGVja2VkKQpmcmVlX3Jvb3QgPSAw
CmZyZWVfbGV2ZWwgPSAwCgpBRyAyCm1hZ2ljbnVtID0gMHg1ODQxNDc0OQp2ZXJzaW9ubnVt
ID0gMQpzZXFubyA9IDIKbGVuZ3RoID0gMjY4NDM1NDU1CmNvdW50ID0gMTUzODc1ODQKcm9v
dCA9IDY0NApsZXZlbCA9IDMKZnJlZWNvdW50ID0gNDUKbmV3aW5vID0gNTA4MTUwNApkaXJp
bm8gPSBudWxsCnVubGlua2VkWzAtNjNdID0gCnV1aWQgPSAwMDAwMDAwMC0wMDAwLTAwMDAt
MDAwMC0wMDAwMDAwMDAwMDAKbHNuID0gMApjcmMgPSAwICh1bmNoZWNrZWQpCmZyZWVfcm9v
dCA9IDAKZnJlZV9sZXZlbCA9IDAKCkFHIDMKbWFnaWNudW0gPSAweDU4NDE0NzQ5CnZlcnNp
b25udW0gPSAxCnNlcW5vID0gMwpsZW5ndGggPSAyNjg0MzU0NTUKY291bnQgPSAxNDk1ODUy
OApyb290ID0gMzE3MjA3CmxldmVsID0gMwpmcmVlY291bnQgPSAzODEKbmV3aW5vID0gNTAz
NDExMgpkaXJpbm8gPSBudWxsCnVubGlua2VkWzAtNjNdID0gCnV1aWQgPSAwMDAwMDAwMC0w
MDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAKbHNuID0gMApjcmMgPSAwICh1bmNoZWNrZWQp
CmZyZWVfcm9vdCA9IDAKZnJlZV9sZXZlbCA9IDAKCkFHIDQKbWFnaWNudW0gPSAweDU4NDE0
NzQ5CnZlcnNpb25udW0gPSAxCnNlcW5vID0gNApsZW5ndGggPSAyNjg0MzU0NTUKY291bnQg
PSA0MDk2OTYwCnJvb3QgPSAzMjA1MjAKbGV2ZWwgPSAyCmZyZWVjb3VudCA9IDExMDA5Cm5l
d2lubyA9IDUwNzk4NzIKZGlyaW5vID0gbnVsbAp1bmxpbmtlZFswLTYzXSA9IAp1dWlkID0g
MDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAwCmxzbiA9IDAKY3JjID0gMCAo
dW5jaGVja2VkKQpmcmVlX3Jvb3QgPSAwCmZyZWVfbGV2ZWwgPSAwCgpBRyA1Cm1hZ2ljbnVt
ID0gMHg1ODQxNDc0OQp2ZXJzaW9ubnVtID0gMQpzZXFubyA9IDUKbGVuZ3RoID0gMjY4NDM1
NDU1CmNvdW50ID0gNDM0MDQxNgpyb290ID0gNzQzCmxldmVsID0gMgpmcmVlY291bnQgPSA2
NzQ4Cm5ld2lubyA9IDUxNTAyMDgKZGlyaW5vID0gbnVsbAp1bmxpbmtlZFswLTYzXSA9IAp1
dWlkID0gMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAwCmxzbiA9IDAKY3Jj
ID0gMCAodW5jaGVja2VkKQpmcmVlX3Jvb3QgPSAwCmZyZWVfbGV2ZWwgPSAwCgpBRyA2Cm1h
Z2ljbnVtID0gMHg1ODQxNDc0OQp2ZXJzaW9ubnVtID0gMQpzZXFubyA9IDYKbGVuZ3RoID0g
MjY4NDM1NDU1CmNvdW50ID0gNDk4Nzk2OApyb290ID0gMTU1ODc5CmxldmVsID0gMgpmcmVl
Y291bnQgPSA2NjMKbmV3aW5vID0gNDkzNzQ3MgpkaXJpbm8gPSBudWxsCnVubGlua2VkWzAt
NjNdID0gCnV1aWQgPSAwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAKbHNu
ID0gMApjcmMgPSAwICh1bmNoZWNrZWQpCmZyZWVfcm9vdCA9IDAKZnJlZV9sZXZlbCA9IDAK
CkFHIDcKbWFnaWNudW0gPSAweDU4NDE0NzQ5CnZlcnNpb25udW0gPSAxCnNlcW5vID0gNwps
ZW5ndGggPSAyNjg0MzU0NTUKY291bnQgPSAzMzIxNzkyCnJvb3QgPSA1NDM4MTUKbGV2ZWwg
PSAyCmZyZWVjb3VudCA9IDU5NQpuZXdpbm8gPSAxMzY5NTIzMgpkaXJpbm8gPSBudWxsCnVu
bGlua2VkWzAtNjNdID0gCnV1aWQgPSAwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAw
MDAwMDAKbHNuID0gMApjcmMgPSAwICh1bmNoZWNrZWQpCmZyZWVfcm9vdCA9IDAKZnJlZV9s
ZXZlbCA9IDAKCkFHIDgKbWFnaWNudW0gPSAweDU4NDE0NzQ5CnZlcnNpb25udW0gPSAxCnNl
cW5vID0gOApsZW5ndGggPSAyNjg0MzU0NTUKY291bnQgPSA1MDQxODU2CnJvb3QgPSA1MDc0
MTAKbGV2ZWwgPSAyCmZyZWVjb3VudCA9IDY5MwpuZXdpbm8gPSA1MDU3ODU2CmRpcmlubyA9
IG51bGwKdW5saW5rZWRbMC02M10gPSAKdXVpZCA9IDAwMDAwMDAwLTAwMDAtMDAwMC0wMDAw
LTAwMDAwMDAwMDAwMApsc24gPSAwCmNyYyA9IDAgKHVuY2hlY2tlZCkKZnJlZV9yb290ID0g
MApmcmVlX2xldmVsID0gMAoKQUcgOQptYWdpY251bSA9IDB4NTg0MTQ3NDkKdmVyc2lvbm51
bSA9IDEKc2Vxbm8gPSA5Cmxlbmd0aCA9IDI2ODQzNTQ1NQpjb3VudCA9IDU0ODUzNzYKcm9v
dCA9IDIwOApsZXZlbCA9IDIKZnJlZWNvdW50ID0gOTA4OQpuZXdpbm8gPSA1MTM0OTEyCmRp
cmlubyA9IG51bGwKdW5saW5rZWRbMC02M10gPSAKdXVpZCA9IDAwMDAwMDAwLTAwMDAtMDAw
MC0wMDAwLTAwMDAwMDAwMDAwMApsc24gPSAwCmNyYyA9IDAgKHVuY2hlY2tlZCkKZnJlZV9y
b290ID0gMApmcmVlX2xldmVsID0gMAoKQUcgMTAKbWFnaWNudW0gPSAweDU4NDE0NzQ5CnZl
cnNpb25udW0gPSAxCnNlcW5vID0gMTAKbGVuZ3RoID0gMjY4NDM1NDU1CmNvdW50ID0gNTIz
MzA4OApyb290ID0gODIxCmxldmVsID0gMgpmcmVlY291bnQgPSAzNzEyMgpuZXdpbm8gPSA1
MDYwNDE2CmRpcmlubyA9IG51bGwKdW5saW5rZWRbMC02M10gPSAKdXVpZCA9IDAwMDAwMDAw
LTAwMDAtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMApsc24gPSAwCmNyYyA9IDAgKHVuY2hlY2tl
ZCkKZnJlZV9yb290ID0gMApmcmVlX2xldmVsID0gMAoKQUcgMTEKbWFnaWNudW0gPSAweDU4
NDE0NzQ5CnZlcnNpb25udW0gPSAxCnNlcW5vID0gMTEKbGVuZ3RoID0gMjY4NDM1NDU1CmNv
dW50ID0gNTgxMDQzMgpyb290ID0gMzQ5ODM3CmxldmVsID0gMgpmcmVlY291bnQgPSAyNjU3
Cm5ld2lubyA9IDUxMDI4ODAKZGlyaW5vID0gbnVsbAp1bmxpbmtlZFswLTYzXSA9IAp1dWlk
ID0gMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAwCmxzbiA9IDAKY3JjID0g
MCAodW5jaGVja2VkKQpmcmVlX3Jvb3QgPSAwCmZyZWVfbGV2ZWwgPSAwCgpBRyAxMgptYWdp
Y251bSA9IDB4NTg0MTQ3NDkKdmVyc2lvbm51bSA9IDEKc2Vxbm8gPSAxMgpsZW5ndGggPSAy
Njg0MzU0NTUKY291bnQgPSA1MjcxNTUyCnJvb3QgPSAzMTQKbGV2ZWwgPSAyCmZyZWVjb3Vu
dCA9IDYwNDk3Cm5ld2lubyA9IDUwNTA1MjgKZGlyaW5vID0gbnVsbAp1bmxpbmtlZFswLTYz
XSA9IAp1dWlkID0gMDAwMDAwMDAtMDAwMC0wMDAwLTAwMDAtMDAwMDAwMDAwMDAwCmxzbiA9
IDAKY3JjID0gMCAodW5jaGVja2VkKQpmcmVlX3Jvb3QgPSAwCmZyZWVfbGV2ZWwgPSAwCgpB
RyAxMwptYWdpY251bSA9IDB4NTg0MTQ3NDkKdmVyc2lvbm51bSA9IDEKc2Vxbm8gPSAxMwps
ZW5ndGggPSAyNjg0MzU0NTUKY291bnQgPSA1NDY0MDAwCnJvb3QgPSA5OTIKbGV2ZWwgPSAy
CmZyZWVjb3VudCA9IDE3OTAyNzUKbmV3aW5vID0gNTA2NzgwOApkaXJpbm8gPSBudWxsCnVu
bGlua2VkWzAtNjNdID0gCnV1aWQgPSAwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAw
MDAwMDAKbHNuID0gMApjcmMgPSAwICh1bmNoZWNrZWQpCmZyZWVfcm9vdCA9IDAKZnJlZV9s
ZXZlbCA9IDAKCkFHIDE0Cm1hZ2ljbnVtID0gMHg1ODQxNDc0OQp2ZXJzaW9ubnVtID0gMQpz
ZXFubyA9IDE0Cmxlbmd0aCA9IDEyMzczOTEwOApjb3VudCA9IDM2NTQ0MApyb290ID0gOTQ1
CmxldmVsID0gMgpmcmVlY291bnQgPSA1NDU0NApuZXdpbm8gPSA1MDg0MjI0CmRpcmlubyA9
IG51bGwKdW5saW5rZWRbMC02M10gPSAKdXVpZCA9IDAwMDAwMDAwLTAwMDAtMDAwMC0wMDAw
LTAwMDAwMDAwMDAwMApsc24gPSAwCmNyYyA9IDAgKHVuY2hlY2tlZCkKZnJlZV9yb290ID0g
MApmcmVlX2xldmVsID0gMAo=
--------------020906040403040503030603
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------020906040403040503030603--
