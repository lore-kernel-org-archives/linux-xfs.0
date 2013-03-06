Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 28FD88012
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 07:12:50 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ED9DB8F8092
	for <xfs@oss.sgi.com>; Wed,  6 Mar 2013 05:12:46 -0800 (PST)
Received: from mail-ee0-f52.google.com (mail-ee0-f52.google.com
	[74.125.83.52]) by cuda.sgi.com with ESMTP id 9jZn9gsiTPQO5w4l
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Mar 2013 05:12:45 -0800 (PST)
Received: by mail-ee0-f52.google.com with SMTP id b15so5527696eek.11
	for <xfs@oss.sgi.com>; Wed, 06 Mar 2013 05:12:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51373FC1.6010101@redhat.com>
References: <CAOdS1h=7X4O1O7X8YOwxtLm7G=fc+J+6hJxJ1RKbDmfTZXTpeg@mail.gmail.com>
	<51373DB8.2020707@redhat.com>
	<CAOdS1hnXGj9puaHxeToqmpK40A-3WvJnM7=5HckpyyZYqZTvEQ@mail.gmail.com>
	<51373FC1.6010101@redhat.com>
From: Supratik Goswami <supratik.goswami@webyog.com>
Date: Wed, 6 Mar 2013 18:42:23 +0530
Message-ID: <CAOurMUeasru6ekDYcvVR1QnaWVJFV+-coZsUG5SgG6LnENBvXg@mail.gmail.com>
Subject: Re: XFS filesystem on EC2 instance corrupts and shuts down
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9057024527013613516=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Shrinath M <shrinath.m@webyog.com>, Sabyasachi Ruj <sabyasachi.ruj@webyog.com>, Vivek Goel <vivek.goel@webyog.com>, xfs@oss.sgi.com

--===============9057024527013613516==
Content-Type: multipart/alternative; boundary=047d7b3a805e7a19e404d7415844

--047d7b3a805e7a19e404d7415844
Content-Type: text/plain; charset=UTF-8

Have we created a ticket with AWS ?

It could be an EBS issue who knows, we need to confirm that first.

--
Warm Regards

Supratik


On Wed, Mar 6, 2013 at 6:38 PM, Ric Wheeler <rwheeler@redhat.com> wrote:

> On 03/06/2013 08:03 AM, Shrinath M wrote:
>
>
>> On Wed, Mar 6, 2013 at 6:29 PM, Ric Wheeler <rwheeler@redhat.com <mailto:
>> rwheeler@redhat.com>> wrote:
>>
>>     I think that you would need to verify that the Amazon storage is not
>>     throwing errors - do your logs show IO errors or issues before XFS
>> hits an
>>     issue?
>>
>>
>> No IO errors in /var/log/messages.
>> Where else should I be looking?
>>
>>
>>
> Feb 12 19:47:18 ip-100-0-100-1 kernel: [2541168.023638] XFS (md0): I/O
> Error Detected. Shutting down filesystem
>
> Is an IO error from MD.
>
> I would suggest trying to reproduce without MD in the picture first -
> always best to try to reproduce with the simplest setup first and work your
> way up the complexity ladder,
>
> Ric
>
>

--047d7b3a805e7a19e404d7415844
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<font><font face=3D"courier new,monospace">Have we created a ticket with AW=
S ?</font></font><div><font><font face=3D"courier new,monospace"><br></font=
></font></div><div><font><font face=3D"courier new,monospace">It could be a=
n EBS issue who knows, we need to confirm that first.<br clear=3D"all">

</font></font><div><font face=3D"&#39;courier new&#39;, monospace"><div><br=
></div><div>--</div>Warm Regards<br><br>Supratik</font></div>
<br><br><div class=3D"gmail_quote">On Wed, Mar 6, 2013 at 6:38 PM, Ric Whee=
ler <span dir=3D"ltr">&lt;<a href=3D"mailto:rwheeler@redhat.com" target=3D"=
_blank">rwheeler@redhat.com</a>&gt;</span> wrote:<br><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">

On 03/06/2013 08:03 AM, Shrinath M wrote:<div class=3D"im"><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
On Wed, Mar 6, 2013 at 6:29 PM, Ric Wheeler &lt;<a href=3D"mailto:rwheeler@=
redhat.com" target=3D"_blank">rwheeler@redhat.com</a> &lt;mailto:<a href=3D=
"mailto:rwheeler@redhat.com" target=3D"_blank">rwheeler@redhat.com</a>&gt;&=
gt; wrote:<br>


<br>
=C2=A0 =C2=A0 I think that you would need to verify that the Amazon storage=
 is not<br>
=C2=A0 =C2=A0 throwing errors - do your logs show IO errors or issues befor=
e XFS hits an<br>
=C2=A0 =C2=A0 issue?<br>
<br>
<br>
No IO errors in /var/log/messages.<br>
Where else should I be looking?<br>
<br>
<br>
</blockquote>
<br></div>
Feb 12 19:47:18 ip-100-0-100-1 kernel: [2541168.023638] XFS (md0): I/O Erro=
r Detected. Shutting down filesystem<br>
<br>
Is an IO error from MD.<br>
<br>
I would suggest trying to reproduce without MD in the picture first - alway=
s best to try to reproduce with the simplest setup first and work your way =
up the complexity ladder,<br>
<br>
Ric<br>
<br>
</blockquote></div><br></div>

--047d7b3a805e7a19e404d7415844--


--===============9057024527013613516==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9057024527013613516==--
