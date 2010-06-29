Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5TEIwMV081602 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 09:18:58 -0500
Received: from fg-out-2122.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 533861E1862C
	for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 07:21:43 -0700 (PDT)
Received: from fg-out-2122.google.com (fg-out-2122.google.com [72.14.220.24])
	by cuda.sgi.com with ESMTP id bQIHlOAAvkoHCC2g for
	<xfs@oss.sgi.com>; Tue, 29 Jun 2010 07:21:43 -0700 (PDT)
Received: by fg-out-2122.google.com with SMTP id e9so77959fga.8
	for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 07:21:42 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <001636458d40cae4e1048a2bf4e9@google.com>
Date: Tue, 29 Jun 2010 14:21:42 +0000
Subject: XFS and Extended ACLs
From: nailman23@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0093061970114634072=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0093061970114634072==
Content-Type: multipart/alternative; boundary=001636458d40cae4ce048a2bf4e6

--001636458d40cae4ce048a2bf4e6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes

Hi All,

I have an issue with extended ACLs. The situation is as follows:
1) There are two users (UserA and UserB)
2) They belong to the same group (users)
3) The SAMBA share called "test" has user access enabled for UserA and UserB
4) The UserA creates test.docx file on the "test" share and he becomes the  
owner of the file.
5) Then UserB edits the test.docx file and save changes. After that UserB  
becomes the owner. It is not an issue because when editing the file Word  
creates new temporary file and then, during saving, overwrites the original  
file. The issue is when you check ACLs entry you will see that UserA has  
his own ACLs entries, although he already belongs to the "users" groups.

This occurs when the share has XFS file system in the bottom.

Then I have created an ext3 file system on the logical volume and after  
performing all steps, the UserB was owner of the file, but the UserA was no  
longer listed in ACLs entries.

It seems the issue comes from XFS and the way as the XFS handles the ACLs  
permissions.

The smb.conf is exactly the same in both cases so I do not believe it is  
SAMBA issue, but if you want I can send the smb.conf file.

Do you know if there is way I could overcome this, in other words, that XFS  
would behave in the same manner as ie ext3.

Thank you in advance.

Slawek

--001636458d40cae4ce048a2bf4e6
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi All,<br /><br />I have an issue with extended ACLs. The situation is as =
follows:<br />1) There are two users (UserA and UserB)<br />2) They belong =
to the same group (users)<br />3) The SAMBA share called &quot;test&quot; h=
as user access enabled for UserA and UserB<br />4) The UserA creates test.d=
ocx file on the &quot;test&quot; share and he becomes the owner of the file=
.<br />5) Then UserB edits the test.docx file and save changes. After that =
UserB becomes the owner. It is not an issue because when editing the file W=
ord creates new temporary file and then, during saving, overwrites the orig=
inal file. The issue is when you check ACLs entry you will see that UserA h=
as his own ACLs entries, although he already belongs to the &quot;users&quo=
t; groups.<br /><br />This occurs when the share has XFS file system in the=
 bottom.<br /><br />Then I have created an ext3 file system on the logical =
volume and after performing all steps, the UserB was owner of the file, but=
 the UserA was no longer listed in ACLs entries.<br /><br />It seems the is=
sue comes from XFS and the way as the XFS handles the ACLs permissions. <br=
 /><br />The smb.conf is exactly the same in both cases so I do not believe=
 it is SAMBA issue, but if you want I can send the smb.conf file.<br /><br =
/>Do you know if there is way I could overcome this, in other words, that X=
FS would behave in the same manner as i.e. ext3.<br /><br />Thank you in ad=
vance.<br /><br />Slawek
--001636458d40cae4ce048a2bf4e6--


--===============0093061970114634072==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0093061970114634072==--
