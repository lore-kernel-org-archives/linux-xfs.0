Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JCHHuj086216 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:17:17 -0500
Received: from ixe-mta-29.emailfiltering.com (ixe-mta-29-tx.emailfiltering.com
	[194.116.199.160]) by cuda.sgi.com with ESMTP id
	2rASnkevF7yOOgGL for <xfs@oss.sgi.com>;
	Tue, 19 Jun 2012 05:17:15 -0700 (PDT)
Message-ID: <4FE06DC7.2060204@pml.ac.uk>
Date: Tue, 19 Jun 2012 13:17:11 +0100
From: Mike Grant <mggr@pml.ac.uk>
MIME-Version: 1.0
Subject: Re: Recommendation on XFS Filesystem Creation, Lefthand P4500, iSCSI ?
References: <4FE050C2.8060601@fiton.is>
In-Reply-To: <4FE050C2.8060601@fiton.is>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: =?ISO-8859-1?Q?Svavar_=D6rn_Eysteinsson?= <svavar@fiton.is>
Cc: xfs@oss.sgi.com

Hi Svavar,

On 06/19/2012 11:13 AM, Svavar =D6rn Eysteinsson wrote:
> We recently purchased HP Lefthand 4500 G2 24TB iSCSI SAN Box.
> The Box is configured in RAID6. (and yes, we are going to expand that with
> another boxes in near future).
> I need to create a 7TB volume at the start, and grow it in near future.

We have a couple of NAS servers (just direct disk connection, not iSCSI) =

with XFS filesystems up to ~30TB, but didn't do anything special for =

those (just defaults on everything, iirc).

The only problem we had was with filesystems bigger than that, where we =

get kernel crashes due to XFS overflowing the stack.  Apparently this =

may be worse if you NFS-share XFS layered over LVM (more stuff on the =

stack, I guess), but I imagine you'd be fine with 7TB.

Cheers,

Mike.

<br />
<hr />
<p><font face=3D"Arial" size=3D"1">
Plymouth Marine Laboratory<br />
Registered Office: <br />
Prospect Place<br />
The Hoe<br />
Plymouth  PL1 3DH
</font></p>

<p><font face=3D"Arial" size=3D"1">Website: <a href=3D"http://www.pml.ac.uk=
">www.pml.ac.uk</a>
<br />
<a href=3D"http://www.pml.ac.uk/pdf/PML%20Annual%20Review%202011_2.pdf">Cli=
ck here for the latest PML Annual Review</a>
<br />
Registered Charity No. 1091222<br />
PML is a company limited by guarantee<br />
registered in England & Wales<br />
company number 4178503</font></p>

<p><font face=3D"Arial" size=3D"1" color=3D"green">Please think before you =
print.</font></p>

<hr />

<p><font face=3D"Arial" size=3D"1">This e-mail, its content and any file at=
tachments are confidential.</font></p>

<p><font face=3D"Arial" size=3D"1">If you have received this e-mail in erro=
r please do not copy, disclose it to any third party or use the contents or=
 attachments in any way. Please notify the sender by replying to this e-mai=
l or e-mail forinfo@pml.ac.uk and then delete the email without making any =
copies or using it in any other way.</font></p>

<p><font face=3D"Arial" size=3D"1">The content of this message may contain =
personal views which are not the views of Plymouth Marine Laboratory unless=
 specifically stated.</font></p>

<p><font face=3D"Arial" size=3D"1">You are reminded that e-mail communicati=
ons are not secure and may contain viruses. Plymouth Marine Laboratory acce=
pts no liability for any loss or damage which may be caused by viruses.</fo=
nt></p>

<hr />
<br />
<br />

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
