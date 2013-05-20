Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5BDE029DF8
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 03:29:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 387118F8033
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 01:29:32 -0700 (PDT)
Received: from mail-wg0-f46.google.com (mail-wg0-f46.google.com
	[74.125.82.46]) by cuda.sgi.com with ESMTP id VK3LXQJ3RH6ZQckt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 01:29:30 -0700 (PDT)
Received: by mail-wg0-f46.google.com with SMTP id l18so817475wgh.13
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 01:29:30 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 20 May 2013 17:29:29 +0900
Message-ID: <CANW9uytRpGXcd9x=HWMEoFvd3_9G98CN_Tv3YacTtd1h+Gq=4g@mail.gmail.com>
Subject: [PATCH] xfstests comma separated group names
From: Itaru Kitayama <itaru.kitayama@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3309602223468069486=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3309602223468069486==
Content-Type: multipart/alternative; boundary=f46d04388df1a3726d04dd2221d3

--f46d04388df1a3726d04dd2221d3
Content-Type: text/plain; charset=ISO-8859-1

This patch lets the -g option take multiple group names.

Signed-off-By: Itaru Kitayama <itaru.kitayama@gmail.com>

 check |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/check b/check
index a79747e..0e0f208 100755
--- a/check
+++ b/check
@@ -164,18 +164,19 @@ while [ $# -gt 0 ]; do
        -nfs)   FSTYP=nfs ;;

        -g)     group=$2 ; shift ;
-               group_list=$(get_group_list $group)
-               if [ -z "$group_list" ]; then
-                   echo "Group \"$group\" is empty or not defined?"
-                   exit 1
-               fi
-
-               [ ! -s $tmp.list ] && touch $tmp.list
-               for t in $group_list; do
-                       grep -s "^$t\$" $tmp.list >/dev/null || \
-                                                       echo "$t"
>>$tmp.list
+               for g in ${group//,/ }; do
+                       group_list=$(get_group_list $g)
+                       if [ -z "$group_list" ]; then
+                       echo "Group \"$g\" is empty or not defined?"
+                       exit 1
+                       fi
+
+                       [ ! -s $tmp.list ] && touch $tmp.list
+                       for t in $group_list; do
+                               grep -s "^$t\$" $tmp.list >/dev/null || \
+                                                               echo "$t"
>>$tmp
+                       done
                done
-
                ;;

        -x)     xgroup=$2 ; shift ;

--f46d04388df1a3726d04dd2221d3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div style>This patch lets the -g option take multiple gro=
up names.</div><div style><br></div><div style>Signed-off-By: Itaru Kitayam=
a &lt;<a href=3D"mailto:itaru.kitayama@gmail.com">itaru.kitayama@gmail.com<=
/a>&gt;</div>
<div><br></div><div>=A0check | =A0 23 ++++++++++++-----------</div><div>=A0=
1 file changed, 12 insertions(+), 11 deletions(-)</div><div><br></div><div>=
diff --git a/check b/check</div><div>index a79747e..0e0f208 100755</div><di=
v>
--- a/check</div><div>+++ b/check</div><div>@@ -164,18 +164,19 @@ while [ $=
# -gt 0 ]; do</div><div>=A0 =A0 =A0 =A0 -nfs) =A0 FSTYP=3Dnfs ;;</div><div>=
=A0</div><div>=A0 =A0 =A0 =A0 -g) =A0 =A0 group=3D$2 ; shift ;</div><div>- =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 group_list=3D$(get_group_list $group)</div>
<div>- =A0 =A0 =A0 =A0 =A0 =A0 =A0 if [ -z &quot;$group_list&quot; ]; then<=
/div><div>- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 echo &quot;Group \&quot;$gr=
oup\&quot; is empty or not defined?&quot;</div><div>- =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 exit 1</div><div>- =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi</div>
<div>-</div><div>- =A0 =A0 =A0 =A0 =A0 =A0 =A0 [ ! -s $tmp.list ] &amp;&amp=
; touch $tmp.list</div><div>- =A0 =A0 =A0 =A0 =A0 =A0 =A0 for t in $group_l=
ist; do</div><div>- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 grep -s &qu=
ot;^$t\$&quot; $tmp.list &gt;/dev/null || \</div>
<div>- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 echo &quot;$t&quot; &gt;&gt;$tmp.li=
st</div><div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 for g in ${group//,/ }; do</div>=
<div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 group_list=3D$(get_group=
_list $g)</div>
<div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if [ -z &quot;$group_lis=
t&quot; ]; then</div><div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ech=
o &quot;Group \&quot;$g\&quot; is empty or not defined?&quot;</div><div>+ =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit 1</div><div>+ =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi</div>
<div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0</div><div>+ =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 [ ! -s $tmp.list ] &amp;&amp; touch $tmp.list</div><div=
>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for t in $group_list; do</di=
v><div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 grep -=
s &quot;^$t\$&quot; $tmp.list &gt;/dev/null || \</div>
<div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 echo &quot;$t&quot;=
 &gt;&gt;$tmp</div><div>+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done<=
/div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done</div><div>-</div><div>=A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 ;;</div><div>
=A0</div><div>=A0 =A0 =A0 =A0 -x) =A0 =A0 xgroup=3D$2 ; shift ;</div></div>

--f46d04388df1a3726d04dd2221d3--


--===============3309602223468069486==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3309602223468069486==--
