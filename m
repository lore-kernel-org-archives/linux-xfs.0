Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 37B3F7F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 22:45:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CEAECAC003
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 20:45:33 -0700 (PDT)
Received: from mail-pb0-f54.google.com (mail-pb0-f54.google.com
	[209.85.160.54]) by cuda.sgi.com with ESMTP id ypJwj7bsSOGHlJ1B
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 20:45:32 -0700 (PDT)
Received: by mail-pb0-f54.google.com with SMTP id ro12so173080pbb.13
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 20:45:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130521004553.GL24543@dastard>
References: <CANW9uytRpGXcd9x=HWMEoFvd3_9G98CN_Tv3YacTtd1h+Gq=4g@mail.gmail.com>
	<20130520113045.GB24543@dastard>
	<CANW9uytQDPaBr_VAGMuwSqhStCfyMCGmV_A3ccNzOExi-KeZfQ@mail.gmail.com>
	<20130521004553.GL24543@dastard>
Date: Tue, 21 May 2013 12:45:32 +0900
Message-ID: <CANW9uyvUgS6i+z0iUtyuJDe2YhbtnVYmYs87xB74=fJCMuG06Q@mail.gmail.com>
Subject: Re: [PATCH] xfstests comma separated group names
From: Itaru Kitayama <itaru.kitayama@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0353587409100609136=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0353587409100609136==
Content-Type: multipart/alternative; boundary=047d7b15b079f58dd204dd324721

--047d7b15b079f58dd204dd324721
Content-Type: text/plain; charset=ISO-8859-1

In the current check script the -g option assumes only one group is given.
With this patch, the -g option
understands comma separated multiple groups as the argument as well.
Existing scripts are not affected
by this patch.

Reviewed-by: Dave Chinner <david@redhat.com>
Signed-off-by: Itaru Kitayama <itaru.kitayama@gmail.com>

---

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


On Tue, May 21, 2013 at 9:45 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, May 20, 2013 at 08:42:35PM +0900, Itaru Kitayama wrote:
> > Yes, we can do that, but I just thought as you originally proposed last
> year
> >
> > -g rw,attr reads better.
>
> Agreed, it does read better and is easily to type.
>
> That's what you need to put in the commit message - why it is better
> than what we currently have, and whether it is badwards compatible
> or not (doesn't break any existing scripts). i.e. the commit
> message is for telling people -why- the change should be made as we
> can look at the code to determine -what- the change is.  ;)
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7b15b079f58dd204dd324721
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div style=3D"font-family:arial,sans-serif;font-size:13px"=
>In the current check script the -g option assumes only one group is given.=
 With this patch, the -g option=A0</div><div style=3D"font-family:arial,san=
s-serif;font-size:13px">
understands comma separated multiple groups as the argument as well. Existi=
ng scripts are not affected=A0</div><div style=3D"font-family:arial,sans-se=
rif;font-size:13px">by this patch.=A0</div><div style=3D"font-family:arial,=
sans-serif;font-size:13px">
<br></div><div style=3D"font-family:arial,sans-serif;font-size:13px">Review=
ed-by: Dave Chinner &lt;<a href=3D"mailto:david@redhat.com">david@redhat.co=
m</a>&gt;</div><div style=3D"font-family:arial,sans-serif;font-size:13px">S=
igned-off-by: Itaru Kitayama &lt;<a href=3D"mailto:itaru.kitayama@gmail.com=
" target=3D"_blank">itaru.kitayama@gmail.com</a>&gt;</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px"><br></div><div s=
tyle=3D"font-family:arial,sans-serif;font-size:13px">---</div><div style=3D=
"font-family:arial,sans-serif;font-size:13px"><br></div><div style=3D"font-=
family:arial,sans-serif;font-size:13px">
=A0check | =A0 23 ++++++++++++-----------</div><div style=3D"font-family:ar=
ial,sans-serif;font-size:13px">=A01 file changed, 12 insertions(+), 11 dele=
tions(-)</div><div style=3D"font-family:arial,sans-serif;font-size:13px"><b=
r></div>
<div style=3D"font-family:arial,sans-serif;font-size:13px">diff --git a/che=
ck b/check</div><div style=3D"font-family:arial,sans-serif;font-size:13px">=
index a79747e..0e0f208 100755</div><div style=3D"font-family:arial,sans-ser=
if;font-size:13px">
--- a/check</div><div style=3D"font-family:arial,sans-serif;font-size:13px"=
>+++ b/check</div><div style=3D"font-family:arial,sans-serif;font-size:13px=
">@@ -164,18 +164,19 @@ while [ $# -gt 0 ]; do</div><div style=3D"font-fami=
ly:arial,sans-serif;font-size:13px">
=A0 =A0 =A0 =A0 -nfs) =A0 FSTYP=3Dnfs ;;</div><div style=3D"font-family:ari=
al,sans-serif;font-size:13px">=A0</div><div style=3D"font-family:arial,sans=
-serif;font-size:13px">=A0 =A0 =A0 =A0 -g) =A0 =A0 group=3D$2 ; shift ;</di=
v><div style=3D"font-family:arial,sans-serif;font-size:13px">
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 group_list=3D$(get_group_list $group)</div><d=
iv style=3D"font-family:arial,sans-serif;font-size:13px">- =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 if [ -z &quot;$group_list&quot; ]; then</div><div style=3D"font=
-family:arial,sans-serif;font-size:13px">
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 echo &quot;Group \&quot;$group\&quot;=
 is empty or not defined?&quot;</div><div style=3D"font-family:arial,sans-s=
erif;font-size:13px">- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit 1</div><div=
 style=3D"font-family:arial,sans-serif;font-size:13px">
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi</div><div style=3D"font-family:arial,sans-=
serif;font-size:13px">-</div><div style=3D"font-family:arial,sans-serif;fon=
t-size:13px">- =A0 =A0 =A0 =A0 =A0 =A0 =A0 [ ! -s $tmp.list ] &amp;&amp; to=
uch $tmp.list</div><div style=3D"font-family:arial,sans-serif;font-size:13p=
x">
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 for t in $group_list; do</div><div style=3D"f=
ont-family:arial,sans-serif;font-size:13px">- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 grep -s &quot;^$t\$&quot; $tmp.list &gt;/dev/null || \</div=
><div style=3D"font-family:arial,sans-serif;font-size:13px">
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 echo &quot;$t&quot; &gt;&gt;$tmp.list</=
div><div style=3D"font-family:arial,sans-serif;font-size:13px">+ =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 for g in ${group//,/ }; do</div><div style=3D"font-fami=
ly:arial,sans-serif;font-size:13px">
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 group_list=3D$(get_group_list=
 $g)</div><div style=3D"font-family:arial,sans-serif;font-size:13px">+ =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if [ -z &quot;$group_list&quot; ]; =
then</div><div style=3D"font-family:arial,sans-serif;font-size:13px">
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 echo &quot;Group \&quot;$g\&q=
uot; is empty or not defined?&quot;</div><div style=3D"font-family:arial,sa=
ns-serif;font-size:13px">+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exit=
 1</div><div style=3D"font-family:arial,sans-serif;font-size:13px">
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fi</div><div style=3D"font-fa=
mily:arial,sans-serif;font-size:13px">+ =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0</div=
><div style=3D"font-family:arial,sans-serif;font-size:13px">+ =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 [ ! -s $tmp.list ] &amp;&amp; touch $tmp.li=
st</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px">+ =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for t in $group_list; do</div><div style=3D=
"font-family:arial,sans-serif;font-size:13px">+ =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 grep -s &quot;^$t\$&quot; $tmp.list &gt;/d=
ev/null || \</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px">+ =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 echo &quot;$t&quot; &gt;&gt;$tmp</div>=
<div style=3D"font-family:arial,sans-serif;font-size:13px">+ =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 done</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px">=A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 done</div><div style=3D"font-family:arial,sans-serif;font-s=
ize:13px">-</div><div style=3D"font-family:arial,sans-serif;font-size:13px"=
>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ;;</div>
<div style=3D"font-family:arial,sans-serif;font-size:13px">=A0</div><div st=
yle=3D"font-family:arial,sans-serif;font-size:13px">=A0 =A0 =A0 =A0 -x) =A0=
 =A0 xgroup=3D$2 ; shift ;</div></div><div class=3D"gmail_extra"><br><br><d=
iv class=3D"gmail_quote">
On Tue, May 21, 2013 at 9:45 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div class=3D"im">On Mon, May 20, 2013 at 08:42:35PM +0900, Itaru Kitayama =
wrote:<br>
&gt; Yes, we can do that, but I just thought as you originally proposed las=
t year<br>
&gt;<br>
&gt; -g rw,attr reads better.<br>
<br>
</div>Agreed, it does read better and is easily to type.<br>
<br>
That&#39;s what you need to put in the commit message - why it is better<br=
>
than what we currently have, and whether it is badwards compatible<br>
or not (doesn&#39;t break any existing scripts). i.e. the commit<br>
message is for telling people -why- the change should be made as we<br>
can look at the code to determine -what- the change is. =A0;)<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--047d7b15b079f58dd204dd324721--


--===============0353587409100609136==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0353587409100609136==--
