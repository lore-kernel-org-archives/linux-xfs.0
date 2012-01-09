Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q096qZpd237340 for <xfs@oss.sgi.com>; Mon, 9 Jan 2012 00:52:35 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	P3BbtWCoTexR6sdv for <xfs@oss.sgi.com>;
	Sun, 08 Jan 2012 22:52:33 -0800 (PST)
Received: by iakk12 with SMTP id k12so7120079iak.26
	for <xfs@oss.sgi.com>; Sun, 08 Jan 2012 22:52:33 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 9 Jan 2012 12:22:33 +0530
Message-ID: <CANBXnM=Ec4zp-5AR3JY00taUR+W-G6+ZKJKhDj94uhpeVsp2tw@mail.gmail.com>
Subject: Cyclic Code?
From: Adil Mujeeb <mujeeb.adil@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4780641182796247039=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4780641182796247039==
Content-Type: multipart/alternative; boundary=bcaec52e6013d66cd204b612d7f4

--bcaec52e6013d66cd204b612d7f4
Content-Type: text/plain; charset=ISO-8859-1

Hi list,

i am new to XFS.

I was going through XFS code (2.4 based) for study purpose. Its old but
assuming its bit simple as compare to latest one. Moreover the XFS code /
design structure documents available on the internet is 2.4 based.

The following code snippet is not clear to me (seems cyclic):

---------
...
...
#define XFS_IFORK_NEXTENTS(ip,w)        xfs_ifork_nextents(ip,w)
...
xfs_ifork_nextents(xfs_inode_t *ip, int w)
{
        return XFS_IFORK_NEXTENTS(ip, w);
}
...
...
#define XFS_IFORK_NEXTENTS(ip,w)        XFS_CFORK_NEXTENTS(&ip->i_d, w)
...
#define XFS_CFORK_NEXTENTS(dcp,w)            xfs_cfork_nextents(dcp,w)
...
int
xfs_cfork_nextents(xfs_dinode_core_t *dcp, int w)
{
        return XFS_CFORK_NEXTENTS(dcp, w);
}
----

Am i missing something?
Thanks,
Adil

--bcaec52e6013d66cd204b612d7f4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi list,</div><div><br></div><div>i am new to XFS.</div><div><br></div=
><div>I was going through XFS code (2.4 based) for study purpose. Its old b=
ut assuming its bit simple as compare to latest one. Moreover the XFS code =
/ design structure documents available on the internet is 2.4 based.</div>
<div><br></div><div>The following code snippet is not clear to me (seems cy=
clic):</div><div><br></div><div>---------</div><div>...</div><div>...</div>=
<div>#define XFS_IFORK_NEXTENTS(ip,w) =A0 =A0 =A0 =A0xfs_ifork_nextents(ip,=
w)</div>
<div>...</div><div>xfs_ifork_nextents(xfs_inode_t *ip, int w)</div><div>{</=
div><div>=A0=A0 =A0 =A0 =A0return XFS_IFORK_NEXTENTS(ip, w);</div><div>}</d=
iv><div>...</div><div>...</div><div>#define XFS_IFORK_NEXTENTS(ip,w) =A0 =
=A0 =A0 =A0XFS_CFORK_NEXTENTS(&amp;ip-&gt;i_d, w)</div>
<div>...</div><div>#define XFS_CFORK_NEXTENTS(dcp,w) =A0 =A0 =A0 =A0 =A0 =
=A0xfs_cfork_nextents(dcp,w)</div><div>...</div><div>int=A0</div><div>xfs_c=
fork_nextents(xfs_dinode_core_t *dcp, int w)</div><div>{</div><div>=A0=A0 =
=A0 =A0 =A0return XFS_CFORK_NEXTENTS(dcp, w);</div>
<div>}</div><div>----</div><div><br></div><div>Am i missing something?=A0</=
div><div>Thanks,</div><div>Adil</div>

--bcaec52e6013d66cd204b612d7f4--


--===============4780641182796247039==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4780641182796247039==--
