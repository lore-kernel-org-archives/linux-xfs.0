Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B0F3C7CA1
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2016 07:40:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38D9AAC001
	for <xfs@oss.sgi.com>; Sun,  3 Jul 2016 05:40:10 -0700 (PDT)
Received: from mail-vk0-f51.google.com (mail-vk0-f51.google.com
	[209.85.213.51]) by cuda.sgi.com with ESMTP id NLHvWGX4Z2qhWfVI
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Jul 2016 05:40:08 -0700 (PDT)
Received: by mail-vk0-f51.google.com with SMTP id i63so34016550vkb.2
	for <xfs@oss.sgi.com>; Sun, 03 Jul 2016 05:40:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAxjCEx4sHH+Eo=HnEXR7+EXwV9unHOg53stRkAn9UecHyQpcg@mail.gmail.com>
References: <CAC5UwBi8Skjx90_XC5Z5B8P+CadawBZ3iUabKtm-2ZvrkgocZQ@mail.gmail.com>
	<CAAxjCEx4sHH+Eo=HnEXR7+EXwV9unHOg53stRkAn9UecHyQpcg@mail.gmail.com>
Date: Sun, 3 Jul 2016 13:40:07 +0100
Message-ID: <CAC5UwBg-GQ+Uoqyqk_udSDLoegR36H4Aa7q++G1CXhUo4amK3g@mail.gmail.com>
Subject: Re: High Fragmentation with XFS and NFS Sync
From: Nick Fisk <friskyfisk10@googlemail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3208979694605315339=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

--===============3208979694605315339==
Content-Type: multipart/alternative; boundary=001a113526c40808b30536ba8539

--001a113526c40808b30536ba8539
Content-Type: text/plain; charset=UTF-8

On 3 Jul 2016 1:34 p.m., "Stefan Ring" <stefanrin@gmail.com> wrote:
>
> On Sat, Jul 2, 2016 at 10:52 AM, Nick Fisk <friskyfisk10@googlemail.com>
wrote:
> > Hi, hope someone can help me here.
> >
> > I'm exporting some XFS fs's to ESX via NFS with the sync option
enabled. I'm
> > seeing really heavy fragmentation when multiple VM's are copied onto the
> > share at the same time. I'm also seeing kmem_alloc failures, which is
> > probably the biggest problem as this effectively takes everything down.
> >
>
> The same thing happens with MySQL's InnoDB files if O_DIRECT is in use.
>
> The kmem_alloc failure taking everything down is most likely a result
> of you calling xfs_bmap on these files and does not happen during
> normal use. I've had the same experience some time ago.

Unfortunately this did happen during normal use. It occurred over night
after kicking a bunch copies off. Something like 5 million extents for
10-20 files. I suspect as suggested, it's to do with memory fragmentation.

--001a113526c40808b30536ba8539
Content-Type: text/html; charset=UTF-8

<p dir="ltr"><br>
On 3 Jul 2016 1:34 p.m., &quot;Stefan Ring&quot; &lt;<a href="mailto:stefanrin@gmail.com">stefanrin@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; On Sat, Jul 2, 2016 at 10:52 AM, Nick Fisk &lt;<a href="mailto:friskyfisk10@googlemail.com">friskyfisk10@googlemail.com</a>&gt; wrote:<br>
&gt; &gt; Hi, hope someone can help me here.<br>
&gt; &gt;<br>
&gt; &gt; I&#39;m exporting some XFS fs&#39;s to ESX via NFS with the sync option enabled. I&#39;m<br>
&gt; &gt; seeing really heavy fragmentation when multiple VM&#39;s are copied onto the<br>
&gt; &gt; share at the same time. I&#39;m also seeing kmem_alloc failures, which is<br>
&gt; &gt; probably the biggest problem as this effectively takes everything down.<br>
&gt; &gt;<br>
&gt;<br>
&gt; The same thing happens with MySQL&#39;s InnoDB files if O_DIRECT is in use.<br>
&gt;<br>
&gt; The kmem_alloc failure taking everything down is most likely a result<br>
&gt; of you calling xfs_bmap on these files and does not happen during<br>
&gt; normal use. I&#39;ve had the same experience some time ago.</p>
<p dir="ltr">Unfortunately this did happen during normal use. It occurred over night after kicking a bunch copies off. Something like 5 million extents for 10-20 files. I suspect as suggested, it&#39;s to do with memory fragmentation.<br>
</p>

--001a113526c40808b30536ba8539--


--===============3208979694605315339==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3208979694605315339==--
