Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AB0E7F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 12:59:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0F3B630407A
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:59:14 -0700 (PDT)
Received: from mail-qe0-f44.google.com (mail-qe0-f44.google.com
	[209.85.128.44]) by cuda.sgi.com with ESMTP id NjBVGzatMJ1pzqhJ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:59:12 -0700 (PDT)
Received: by mail-qe0-f44.google.com with SMTP id 3so2090538qeb.3
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:59:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGG-pURO7QrMcU1btzh_RvQkLB=4QFqrLntW3n6BeMfU4iFdUQ@mail.gmail.com>
References: <CAGG-pURO7QrMcU1btzh_RvQkLB=4QFqrLntW3n6BeMfU4iFdUQ@mail.gmail.com>
Date: Fri, 27 Sep 2013 14:59:12 -0300
Message-ID: <CAGG-pUQr39G3QiiS=yoDQk+RmVihr59N8Z6Wk5G05QFB=gJF4g@mail.gmail.com>
Subject: [XFS MAINTAINERS] fs/xfs/xfs_dir2_node.c: xfs: xfs_dir2_leafn_add:
	Variables Uninitialized
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3371274103328678038=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

--===============3371274103328678038==
Content-Type: multipart/alternative; boundary=001a1133beb672e94a04e7613ee4

--001a1133beb672e94a04e7613ee4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Maintainers,

I suppose the variables "highstale" and "lowstale" are being used despite
not having been initialized.

File: fs/xfs/xfs_dir2_node.c
Function: xfs_dir2_leafn_add

L491:
> /*
> * Insert the new entry, log everything.
> */
> lep =3D xfs_dir3_leaf_find_entry(&leafhdr, ents, index, compact, lowstale=
,
> highstale, &lfloglow, &lfloghigh);

The only place they are started up is within this condition:

L480:
> if (compact)
> xfs_dir3_leaf_compact_x1(&leafhdr, ents, &index, &lowstale,
> &highstale, &lfloglow, &lfloghigh);

So, if it is not compact, both have garbage.

Best Regards.

Geyslan Greg=C3=B3rio Bem

--001a1133beb672e94a04e7613ee4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Hi Maintainers,</p>
<p dir=3D"ltr">I suppose the variables &quot;highstale&quot; and &quot;lows=
tale&quot; are being used despite not having been initialized.</p>
<p dir=3D"ltr">File: fs/xfs/xfs_dir2_node.c<br>
Function: xfs_dir2_leafn_add</p>
<p dir=3D"ltr">L491:<br>
&gt; /*<br>
&gt; * Insert the new entry, log everything.<br>
&gt; */<br>
&gt; lep =3D xfs_dir3_leaf_find_entry(&amp;leafhdr, ents, index, compact, l=
owstale,<br>
&gt; highstale, &amp;lfloglow, &amp;lfloghigh);<br></p>
<p dir=3D"ltr">The only place they are started up is within this condition:=
</p>
<p dir=3D"ltr">L480:<br>
&gt; if (compact)<br>
&gt; xfs_dir3_leaf_compact_x1(&amp;leafhdr, ents, &amp;index, &amp;lowstale=
,<br>
&gt; &amp;highstale, &amp;lfloglow, &amp;lfloghigh);<br></p>
<p dir=3D"ltr">So, if it is not compact, both have garbage.</p>
<p dir=3D"ltr">Best Regards.</p>
<p dir=3D"ltr">Geyslan Greg=C3=B3rio Bem</p>

--001a1133beb672e94a04e7613ee4--


--===============3371274103328678038==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3371274103328678038==--
