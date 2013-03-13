Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 37B287F3F
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 13:08:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF6FB304075
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 11:08:17 -0700 (PDT)
Received: from mail-ie0-f172.google.com (mail-ie0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	8VJuZZsp0SadjT8R (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 Mar 2013 11:08:12 -0700 (PDT)
Received: by mail-ie0-f172.google.com with SMTP id c10so1844623ieb.17
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 11:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513751F2.2060109@redhat.com>
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
	<CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
	<513751F2.2060109@redhat.com>
From: Shrinath M <shrinath.m@webyog.com>
Date: Wed, 13 Mar 2013 23:37:52 +0530
Message-ID: <CAOdS1hngSuHn_HiremLyUS7Qd9eZ68=8arfBuHnEpwXQaBw9Wg@mail.gmail.com>
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5038902481087827124=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, xfs@oss.sgi.com, Supratik Goswami <supratik.goswami@webyog.com>, Vivek Goel <vivek.goel@webyog.com>

--===============5038902481087827124==
Content-Type: multipart/alternative; boundary=bcaec5171a230c704b04d7d24a4c

--bcaec5171a230c704b04d7d24a4c
Content-Type: text/plain; charset=UTF-8

Sorry to be asking in dev thread, but Amazon seems to be clueless in this
case :(
Can someone tell me where can we find the logs/output of xfs repair after
this runs? We just reboot the machine when we see this and the
/var/log/messages or dmesg seems to know nothing about what it repaired.


On Wed, Mar 6, 2013 at 7:55 PM, Ric Wheeler <rwheeler@redhat.com> wrote:

> I would suggest contacting Amazon's customer support channel (or the
> vendor you paid for the Linux instance you are running).
>
> XFS developer list is probably not the correct forum to help you debug
> this :)
>
> Good luck!
>
> Ric
>
>
>
> On 03/06/2013 08:12 AM, Supratik Goswami wrote:
>
>> Have we created a ticket with AWS ?
>>
>> It could be an EBS issue who knows, we need to confirm that first.
>>
>> --
>> Warm Regards
>>
>> Supratik
>>
>>
>> On Wed, Mar 6, 2013 at 6:38 PM, Ric Wheeler <rwheeler@redhat.com <mailto:
>> rwheeler@redhat.com>> wrote:
>>
>>     On 03/06/2013 08:03 AM, Shrinath M wrote:
>>
>>
>>         On Wed, Mar 6, 2013 at 6:29 PM, Ric Wheeler <rwheeler@redhat.com
>>         <mailto:rwheeler@redhat.com> <mailto:rwheeler@redhat.com
>>
>>         <mailto:rwheeler@redhat.com>>> wrote:
>>
>>             I think that you would need to verify that the Amazon storage
>> is not
>>             throwing errors - do your logs show IO errors or issues
>> before XFS
>>         hits an
>>             issue?
>>
>>
>>         No IO errors in /var/log/messages.
>>         Where else should I be looking?
>>
>>
>>
>>     Feb 12 19:47:18 ip-100-0-100-1 kernel: [2541168.023638] XFS (md0): I/O
>>     Error Detected. Shutting down filesystem
>>
>>     Is an IO error from MD.
>>
>>     I would suggest trying to reproduce without MD in the picture first -
>>     always best to try to reproduce with the simplest setup first and work
>>     your way up the complexity ladder,
>>
>>     Ric
>>
>>
>>
>>
>> ______________________________**_________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/**listinfo/xfs<http://oss.sgi.com/mailman/listinfo/xfs>
>>
>
>


-- 
Regards
*Shrinath.M*

--bcaec5171a230c704b04d7d24a4c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Sorry to be asking in dev thread, but Amazon seems to be c=
lueless in this case :(<div>Can someone tell me where can we find the logs/=
output of xfs repair after this runs? We just reboot the machine when we se=
e this and the /var/log/messages or dmesg seems to know nothing about what =
it repaired.</div>

</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Wed,=
 Mar 6, 2013 at 7:55 PM, Ric Wheeler <span dir=3D"ltr">&lt;<a href=3D"mailt=
o:rwheeler@redhat.com" target=3D"_blank">rwheeler@redhat.com</a>&gt;</span>=
 wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">I would suggest contacting Amazon&#39;s cust=
omer support channel (or the vendor you paid for the Linux instance you are=
 running).<br>


<br>
XFS developer list is probably not the correct forum to help you debug this=
 :)<br>
<br>
Good luck!<br>
<br>
Ric<div class=3D"im"><br>
<br>
<br>
On 03/06/2013 08:12 AM, Supratik Goswami wrote:<br>
</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex"><div class=3D"im">
Have we created a ticket with AWS ?<br>
<br>
It could be an EBS issue who knows, we need to confirm that first.<br>
<br>
--<br>
Warm Regards<br>
<br>
Supratik<br>
<br>
<br></div><div class=3D"im">
On Wed, Mar 6, 2013 at 6:38 PM, Ric Wheeler &lt;<a href=3D"mailto:rwheeler@=
redhat.com" target=3D"_blank">rwheeler@redhat.com</a> &lt;mailto:<a href=3D=
"mailto:rwheeler@redhat.com" target=3D"_blank">rwheeler@redhat.com</a>&gt;&=
gt; wrote:<br>


<br>
=C2=A0 =C2=A0 On 03/06/2013 08:03 AM, Shrinath M wrote:<br>
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 On Wed, Mar 6, 2013 at 6:29 PM, Ric Wheeler &lt=
;<a href=3D"mailto:rwheeler@redhat.com" target=3D"_blank">rwheeler@redhat.c=
om</a><br></div>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;mailto:<a href=3D"mailto:rwheeler@redhat.co=
m" target=3D"_blank">rwheeler@redhat.com</a>&gt; &lt;mailto:<a href=3D"mail=
to:rwheeler@redhat.com" target=3D"_blank">rwheeler@redhat.com</a><div class=
=3D"im"><br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;mailto:<a href=3D"mailto:rwheeler@redhat.co=
m" target=3D"_blank">rwheeler@redhat.com</a>&gt;&gt;&gt; wrote:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 I think that you would need to ve=
rify that the Amazon storage is not<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 throwing errors - do your logs sh=
ow IO errors or issues before XFS<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hits an<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 issue?<br>
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 No IO errors in /var/log/messages.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Where else should I be looking?<br>
<br>
<br>
<br>
=C2=A0 =C2=A0 Feb 12 19:47:18 ip-100-0-100-1 kernel: [2541168.023638] XFS (=
md0): I/O<br>
=C2=A0 =C2=A0 Error Detected. Shutting down filesystem<br>
<br>
=C2=A0 =C2=A0 Is an IO error from MD.<br>
<br>
=C2=A0 =C2=A0 I would suggest trying to reproduce without MD in the picture=
 first -<br>
=C2=A0 =C2=A0 always best to try to reproduce with the simplest setup first=
 and work<br>
=C2=A0 =C2=A0 your way up the complexity ladder,<br>
<br>
=C2=A0 =C2=A0 Ric<br>
<br>
<br>
<br>
<br></div>
______________________________<u></u>_________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sgi.com</a><br=
>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" target=3D"_blank">http:=
//oss.sgi.com/mailman/<u></u>listinfo/xfs</a><br>
</blockquote>
<br>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><font face=
=3D"&#39;courier new&#39;, monospace" color=3D"#666666">Regards</font><div>=
<b><font face=3D"&#39;courier new&#39;, monospace" color=3D"#666666">Shrina=
th.M</font></b></div>

<div><br></div>
</div>

--bcaec5171a230c704b04d7d24a4c--


--===============5038902481087827124==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5038902481087827124==--
