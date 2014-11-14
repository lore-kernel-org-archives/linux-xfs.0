Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1BD457F3F
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 02:57:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8970AAC005
	for <xfs@oss.sgi.com>; Fri, 14 Nov 2014 00:57:44 -0800 (PST)
Received: from BLU004-OMC4S31.hotmail.com (blu004-omc4s31.hotmail.com
	[65.55.111.170]) by cuda.sgi.com with ESMTP id lQLdSM3BYPXGtYxS
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 14 Nov 2014 00:57:42 -0800 (PST)
Message-ID: <BLU172-W9B4FE524F07D7E6D5592BC48C0@phx.gbl>
From: Robert Tench <robtench@hotmail.com>
Subject: Mismatch UUID
Date: Fri, 14 Nov 2014 19:57:42 +1100
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4822334217686081031=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4822334217686081031==
Content-Type: multipart/alternative;
	boundary="_2ccb4f2b-b880-48a2-a706-4b53b6bb5de4_"

--_2ccb4f2b-b880-48a2-a706-4b53b6bb5de4_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

                                                            Robert has a fi=
le to share with you on OneDrive. To view it=2C click the link below.      =
                                                                           =
                       xfs.log                                             =
                               So finally have managed to find a way to sav=
e the complete log of running xfs_repair -n /dev.md4

And below is the output of xfs_check /dev/md4

root@ubuntu:~# xfs_check /dev/md4
* ERROR: mismatched uuid in log
*            SB : 813833a7-1bd3-4447-b575-09d1471bb652
*            log: ea3833af-25ce-9f91-b575-018fb49df3b1
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log=2C and unmount it befo=
re
re-running xfs_check.  If you are unable to mount the filesystem=2C then us=
e
the xfs_repair -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

And the output from mdadm -D /dev/md4 is as follows

root@ubuntu:~# mdadm -D /dev/md4
/dev/md4:
        Version : 1.0
  Creation Time : Fri Jan  1 01:31:17 2010
     Raid Level : raid5
     Array Size : 11712962560 (11170.35 GiB 11994.07 GB)
  Used Dev Size : 2928240640 (2792.59 GiB 2998.52 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Fri Nov 14 15:58:16 2014
          State : clean=20
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : (none):4
           UUID : e0829810:9782b51f:25529f65:8823419c
         Events : 1243386

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       6       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       5       8       50        3      active sync   /dev/sdd2
       4       8       66        4      active sync   /dev/sde2


And then the response from mdadm -E /dev/md4

root@ubuntu:~# mdadm -E /dev/md4
mdadm: No md superblock detected on /dev/md4.

Not sure what to do=2C any help would be appreciated

Regards=2C

Rob



                 		 	   		  =

--_2ccb4f2b-b880-48a2-a706-4b53b6bb5de4_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 12pt=3B
font-family:Calibri
}
--></style></head>
<body class=3D'hmmessage'><div dir=3D'ltr'><div><script type=3D"jsv#903_"><=
/script>    <table style=3D"height:100%=3Bwidth:100%" class=3D"shareSkyDriv=
eTable"><tbody><tr><td style=3D"padding:0">                    <div id=3D"e=
cx_rte_preskyattach" style=3D"font-size:12pt=3Bfont-family:Calibri=2Csans-s=
erif=3Boutline:none=3Bheight:100%=3B" contenteditable=3D"true"></div>      =
          </td></tr><tr><td class=3D"ShareSkyDriveSection" style=3D"padding=
:30px 0=3B-moz-user-select:none">                    <div style=3D"padding-=
bottom:10px=3Bcolor:#666=3Bfont-size:14px=3B">Robert has a file to share wi=
th you on OneDrive. To view it=2C click the link below.</div>              =
      <script type=3D"jsv#1107^"></script><script type=3D"jsv#904_"></scrip=
t>    <div class=3D"shareSkyDriveImages" style=3D"padding-bottom:10px=3B"> =
       <script type=3D"jsv#1105^"></script><script type=3D"jsv#905_"></scri=
pt><script type=3D"jsv/905_"></script><script type=3D"jsv/1105^"></script> =
   </div>    <div class=3D"shareSkyDriveDocs" style=3D"clear:both=3B">     =
   <script type=3D"jsv#1106^"></script><script type=3D"jsv#906_"></script><=
script type=3D"jsv#907_"></script>        <div class=3D"shareSkyDriveItem" =
style=3D"padding-bottom:10px" objectid=3D"588C9B3E0CC494AE!153" viewlink=3D=
"https://onedrive.live.com/redir.aspx?cid=3D588c9b3e0cc494ae&amp=3Bpage=3Db=
rowse&amp=3Bresid=3D588C9B3E0CC494AE!153&amp=3BparId=3D588C9B3E0CC494AE!128=
" ext=3D".log">            <img src=3D"https://a.gfx.ms/ftype/v4/default.pn=
g" onerror=3D"this.src=3D'https://a.gfx.ms/ftype/v4/default.png'" style=3D"=
display:inline-block=3Bcursor:pointer=3Bmargin-bottom:-3px=3B">            =
    <a href=3D"https://onedrive.live.com/redir.aspx?cid=3D588c9b3e0cc494ae&=
amp=3Bresid=3D588C9B3E0CC494AE!153&amp=3BparId=3D588C9B3E0CC494AE!128&amp=
=3Bauthkey=3D!AIWGW7RzNo1vNTY&amp=3Bithint=3Dfile%2clog" style=3D"font-size=
:10pt=3Bcolor:#0068CF=3B text-decoration:none=3Bpadding-right:20px=3B">    =
                xfs.log                </a>            </div>        <scrip=
t type=3D"jsv/907_"></script><script type=3D"jsv/906_"></script><script typ=
e=3D"jsv/1106^"></script>    </div><script type=3D"jsv/904_"></script><scri=
pt type=3D"jsv/1107^"></script>                </td></tr><tr style=3D"heigh=
t:100%"><td style=3D"height:100%=3Bpadding:0">                    <div id=
=3D"ecx_rte_postskyattach" style=3D"font-size:12pt=3Bfont-family:Calibri=2C=
sans-serif=3Boutline:none=3Bheight:100%=3B" contenteditable=3D"true">So fin=
ally have managed to find a way to save the complete log of running xfs_rep=
air -n /dev.md4<br><br>And below is the output of xfs_check /dev/md4<br><br=
>root@ubuntu:~# xfs_check /dev/md4<br>* ERROR: mismatched uuid in log<br>*&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B SB : 813833a7-1bd3-4447-b575-09d1471bb652<br>*&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B lo=
g: ea3833af-25ce-9f91-b575-018fb49df3b1<br>ERROR: The filesystem has valuab=
le metadata changes in a log which needs to<br>be replayed.&nbsp=3B Mount t=
he filesystem to replay the log=2C and unmount it before<br>re-running xfs_=
check.&nbsp=3B If you are unable to mount the filesystem=2C then use<br>the=
 xfs_repair -L option to destroy the log and attempt a repair.<br>Note that=
 destroying the log may cause corruption -- please attempt a mount<br>of th=
e filesystem before doing this.<br><br>And the output from mdadm -D /dev/md=
4 is as follows<br><br>root@ubuntu:~# mdadm -D /dev/md4<br>/dev/md4:<br>&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Version : 1.0<br>&nbs=
p=3B Creation Time : Fri Jan&nbsp=3B 1 01:31:17 2010<br>&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B Raid Level : raid5<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Array =
Size : 11712962560 (11170.35 GiB 11994.07 GB)<br>&nbsp=3B Used Dev Size : 2=
928240640 (2792.59 GiB 2998.52 GB)<br>&nbsp=3B&nbsp=3B Raid Devices : 5<br>=
&nbsp=3B Total Devices : 5<br>&nbsp=3B&nbsp=3B&nbsp=3B Persistence : Superb=
lock is persistent<br><br>&nbsp=3B&nbsp=3B&nbsp=3B Update Time : Fri Nov 14=
 15:58:16 2014<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B State : clean <br>&nbsp=3BActive Devices : 5<br>Working Dev=
ices : 5<br>&nbsp=3BFailed Devices : 0<br>&nbsp=3B Spare Devices : 0<br><br=
>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Layout : =
left-symmetric<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Chunk Size : 512K<br><br=
>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&n=
bsp=3B Name : (none):4<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B UUID : e0829810:9782b51f:25529f65:8823419c<=
br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B Events =
: 1243386<br><br>&nbsp=3B&nbsp=3B&nbsp=3B Number&nbsp=3B&nbsp=3B Major&nbsp=
=3B&nbsp=3B Minor&nbsp=3B&nbsp=3B RaidDevice State<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 0&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 2&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 0&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B active sync&nbsp=3B&nbsp=3B /dev/sda2<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B 6&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 8&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 18&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 1&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B active sync&nbsp=3B&nbsp=3B /dev/sdb2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B 2&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 34&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B 2&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B acti=
ve sync&nbsp=3B&nbsp=3B /dev/sdc2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B 5&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 50&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B 3&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B active sync&=
nbsp=3B&nbsp=3B /dev/sdd2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B 4&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B 8&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B&nbsp=3B&nbsp=3B 66&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbs=
p=3B&nbsp=3B 4&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B active sync&nbsp=3B&=
nbsp=3B /dev/sde2<br><br><br>And then the response from mdadm -E /dev/md4<b=
r><br>root@ubuntu:~# mdadm -E /dev/md4<br>mdadm: No md superblock detected =
on /dev/md4.<br><br>Not sure what to do=2C any help would be appreciated<br=
><br>Regards=2C<br><br>Rob<br><br><br><br></div>                </td></tr><=
/tbody></table><script type=3D"jsv/903_"></script></div> 		 	   		  </div><=
/body>
</html>=

--_2ccb4f2b-b880-48a2-a706-4b53b6bb5de4_--


--===============4822334217686081031==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4822334217686081031==--
