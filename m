Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8410429DFA
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 23:11:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41FEC304071
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 21:11:18 -0700 (PDT)
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	1UxKtXdQmyNJpoad (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 21:11:16 -0700 (PDT)
Received: by mail-ie0-f171.google.com with SMTP id e11so5458622iej.2
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 21:11:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADFMGu+9SGHJEPtUzuR3eObNwfs6VE0TmJNhJh_vxQ3+KBwocA@mail.gmail.com>
References: <516C89DF.4070904@redhat.com>
	<CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
	<51705EC4.4000306@redhat.com>
	<CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
	<CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
	<51715BD4.8080501@sandeen.net>
	<CADFMGuLjsNBeWE8wTDBgophhpixm3p+wY=9QWwk5u483zL0C4g@mail.gmail.com>
	<CADFMGuKuL8=B_NY=pKq5gj3aOK0kW0xuPWA=rSCDyziUgWGX6w@mail.gmail.com>
	<51716DCB.4060407@sandeen.net>
	<CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
	<CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
	<5171790C.70400@sandeen.net>
	<CADFMGuKfyw-mCsRn1Y5H5ek+z_nRMHDmW4bG-Ez9ANJm7_ec5A@mail.gmail.com>
	<CADFMGuL4+vSH9ZpWODXWbHVz9ndMcg2aZY9b0ccq74SJp3XzEw@mail.gmail.com>
	<CADFMGuK7FEbWibRrctK7B=XXAfAKtpjRej3NVB2k7JXhhYFLLg@mail.gmail.com>
	<CADFMGuJozkBQdp5o_BK7HbrPdv6iKUie=jHyz5LrtBBvHY1b4w@mail.gmail.com>
	<CADFMGuL05J+b=bv5jAneLT451eQFNNz2RNHQHccBOjqWsE68Kw@mail.gmail.com>
	<51720E49.9020001@sandeen.net>
	<CADFMGu+9SGHJEPtUzuR3eObNwfs6VE0TmJNhJh_vxQ3+KBwocA@mail.gmail.com>
Date: Sat, 20 Apr 2013 12:11:16 +0800
Message-ID: <CADFMGuK6Bb=FTkRHbksaMiYvAucYGLsMnh0pKceZJwOnuDPWpw@mail.gmail.com>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7937615122591286374=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7937615122591286374==
Content-Type: multipart/alternative; boundary=bcaec51d2998ebcd4704dac306fd

--bcaec51d2998ebcd4704dac306fd
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

And glusterfs always uses hardlink for sel-heal too(a backend file has a
hardlink under a hidden directory which name is .glusterfs). So as you have
mentioned reduce di_nlink may also conflicts.


2013/4/20 =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com>

> Hi Eric,
> I will enable them and run test again. I can only reproduce it with
> glusterfs rebalance. Glusterfs uses a mechanism it called syncop to unlin=
k
> file. For rebalance it uses
> syncop_unlink(glusterfs/libglusterfs/src/syncop.c). In the glusterfs
> sync_task framework(glusterfs/libglusterfs/src/syncop.c) it uses
> "makecontext/swapcontext"<http://www.opengroup.org/onlinepubs/009695399/f=
unctions/makecontext.html>.
> Does it leads to racing unlink from different CPU core?
> Thank you.
>
>
> 2013/4/20 Eric Sandeen <sandeen@sandeen.net>
>
>> On 4/19/13 7:51 PM, =B7=FB=D3=C0=CC=CE wrote:
>> > After change mount option to sync shutdown still happens, and I got a
>> trace again, the inode 0x1c57d is abnormal.
>>
>> since this is a race on namespace operations, I wouldn't have expected
>> sync to matter.
>>
>> >
>> https://docs.google.com/file/d/0B7n2C4T5tfNCYW1jNWhBbXBYakE/edit?usp=3Ds=
haring
>> > I have a question if the problem is hard to reproduce why I got 8 time=
s
>> in a week only in a test cluster with 8 node?
>> > What's the problem?
>>
>> you must have something unique in your environment, and we don't know
>> what it is.
>>
>> To gather more information, can you also turn on tracepoints for:
>>
>> xfs_rename
>> xfs_create
>> xfs_link
>> xfs_remove
>>
>> in addition to xfs_iunlink and xfs_iunlink_remove,
>> and we'll see what that tells us.
>>
>> There are many paths that manipulate the di_nlink count, and something i=
s
>> racing, but we don't yet know what two callchains they are.
>>
>> The above are all the callers that manipulate the link count, so they
>> will yield more information about who is manipulating the counts.
>>
>> Thanks,
>> -Eric
>>
>>
>
>
> --
> =B7=FB=D3=C0=CC=CE
>



--=20
=B7=FB=D3=C0=CC=CE

--bcaec51d2998ebcd4704dac306fd
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">And glusterfs always uses hardlink for sel-heal too(a back=
end file has a hardlink under a hidden directory which name is .glusterfs).=
 So as you have mentioned reduce di_nlink may also conflicts.<br></div><div=
 class=3D"gmail_extra">
<br><br><div class=3D"gmail_quote">2013/4/20 =B7=FB=D3=C0=CC=CE <span dir=
=3D"ltr">&lt;<a href=3D"mailto:yongtaofu@gmail.com" target=3D"_blank">yongt=
aofu@gmail.com</a>&gt;</span><br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<div dir=3D"ltr"><div><div>Hi Eric,<br></div>I will enable them and run tes=
t again. I can only reproduce it with glusterfs rebalance. Glusterfs uses a=
 mechanism it called syncop to unlink file. For rebalance it uses syncop_un=
link(glusterfs/libglusterfs/src/syncop.c). In the glusterfs sync_task frame=
work(glusterfs/libglusterfs/src/syncop.c) it uses  <a href=3D"http://www.op=
engroup.org/onlinepubs/009695399/functions/makecontext.html" target=3D"_bla=
nk">&quot;makecontext/swapcontext&quot;</a>. Does it leads to racing unlink=
 from different CPU core?<br>

</div>Thank you. <br></div><div class=3D"gmail_extra"><div><div class=3D"h5=
"><br><br><div class=3D"gmail_quote">2013/4/20 Eric Sandeen <span dir=3D"lt=
r">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@san=
deen.net</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<div>On 4/19/13 7:51 PM, =B7=FB=D3=C0=CC=CE wrote:<br>
&gt; After change mount option to sync shutdown still happens, and I got a =
trace again, the inode 0x1c57d is abnormal.<br>
<br>
</div>since this is a race on namespace operations, I wouldn&#39;t have exp=
ected sync to matter.<br>
<div><br>
&gt; <a href=3D"https://docs.google.com/file/d/0B7n2C4T5tfNCYW1jNWhBbXBYakE=
/edit?usp=3Dsharing" target=3D"_blank">https://docs.google.com/file/d/0B7n2=
C4T5tfNCYW1jNWhBbXBYakE/edit?usp=3Dsharing</a><br>
&gt; I have a question if the problem is hard to reproduce why I got 8 time=
s in a week only in a test cluster with 8 node?<br>
&gt; What&#39;s the problem?<br>
<br>
</div>you must have something unique in your environment, and we don&#39;t =
know what it is.<br>
<br>
To gather more information, can you also turn on tracepoints for:<br>
<br>
xfs_rename<br>
xfs_create<br>
xfs_link<br>
xfs_remove<br>
<br>
in addition to xfs_iunlink and xfs_iunlink_remove,<br>
and we&#39;ll see what that tells us.<br>
<br>
There are many paths that manipulate the di_nlink count, and something is r=
acing, but we don&#39;t yet know what two callchains they are.<br>
<br>
The above are all the callers that manipulate the link count, so they will =
yield more information about who is manipulating the counts.<br>
<br>
Thanks,<br>
-Eric<br>
<br>
</blockquote></div><br><br clear=3D"all"><br></div></div><span class=3D"HOE=
nZb"><font color=3D"#888888">-- <br>=B7=FB=D3=C0=CC=CE
</font></span></div>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--bcaec51d2998ebcd4704dac306fd--


--===============7937615122591286374==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7937615122591286374==--
