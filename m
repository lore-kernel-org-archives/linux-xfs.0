Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5354B7F6D
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 09:59:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B4D8304066
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 07:59:32 -0700 (PDT)
Received: from mail-vc0-f179.google.com (mail-vc0-f179.google.com
	[209.85.220.179]) by cuda.sgi.com with ESMTP id
	mzY9K9Zs7JIa7iVe (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Mar 2013 07:59:30 -0700 (PDT)
Received: by mail-vc0-f179.google.com with SMTP id gf12so428762vcb.24
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 07:59:30 -0700 (PDT)
Message-ID: <5141E5CF.10101@binghamton.edu>
Date: Thu, 14 Mar 2013 10:59:27 -0400
From: Dave Hall <kdhall@binghamton.edu>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
	<5141C8C1.2080903@hardwarefreak.com>
In-Reply-To: <5141C8C1.2080903@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1477873668588459734=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--===============1477873668588459734==
Content-Type: multipart/alternative;
 boundary="------------000803040109070900050305"

This is a multi-part message in MIME format.
--------------000803040109070900050305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Dave Hall
Binghamton University
kdhall@binghamton.edu
607-760-2328 (Cell)
607-777-4641 (Office)


On 03/14/2013 08:55 AM, Stan Hoeppner wrote:
>> Yes,  please provide the output of the following commands:
>>      
> ~$ uname -a
>    
Linux decoy 3.2.0-0.bpo.4-amd64 #1 SMP Debian 3.2.35-2~bpo60+1 x86_64 
GNU/Linux
>> >  ~$ grep xfs /etc/fstab
>>      
LABEL=backup        /infortrend    xfs    
inode64,noatime,nodiratime,nobarrier    0    0
(cat /proc/mounts:  /dev/sdb1 /infortrend xfs 
rw,noatime,nodiratime,attr2,delaylog,nobarrier,inode64,noquota 0 0)

Note that there is also a second XFS on a separate 3ware raid card, but 
the I/O traffic on that one is fairly low.  It is used as a staging area 
for a Debian mirror that is hosted on another server.
>> >  ~$ xfs_info/dev/[mount-point]
>>      
# xfs_info /dev/sdb1
meta-data=/dev/sdb1              isize=256    agcount=26, 
agsize=268435455 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=6836364800, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
>> >  ~$ df/dev/[mount_point]
>>      
# df /dev/sdb1
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1            27343372288 20432618356 6910753932  75% /infortrend
>> >  ~$ df -i/dev/[mount_point]
>>      
# df -i /dev/sdb1
Filesystem            Inodes   IUsed   IFree IUse% Mounted on
/dev/sdb1            5469091840 1367746380 4101345460   26% /infortrend
>> >  ~$ xfs_db -r -c freesp/dev/[mount-point]
>>      
# xfs_db -r -c freesp /dev/sdb1
    from      to extents  blocks    pct
       1       1  832735  832735   0.05
       2       3  432183 1037663   0.06
       4       7  365573 1903965   0.11
       8      15  352402 3891608   0.23
      16      31  332762 7460486   0.43
      32      63  300571 13597941   0.79
      64     127  233778 20900655   1.21
     128     255  152003 27448751   1.59
     256     511  112673 40941665   2.37
     512    1023   82262 59331126   3.43
    1024    2047   53238 76543454   4.43
    2048    4095   34092 97842752   5.66
    4096    8191   22743 129915842   7.52
    8192   16383   14453 162422155   9.40
   16384   32767    8501 190601554  11.03
   32768   65535    4695 210822119  12.20
   65536  131071    2615 234787546  13.59
  131072  262143    1354 237684818  13.76
  262144  524287     470 160228724   9.27
  524288 1048575      74 47384798   2.74
1048576 2097151       1 2097122   0.12
>> >  
>> >  Also please provide the make/model of the RAID controller, the write
>> >  cache size and if it is indeed enabled and working, as well as any
>> >  errors, if any, logged by the controller in dmesg or elsewhere in Linux,
>> >  or in the controller firmware.
>> >  
>>      
The RAID box is an Infortrend S16S-G1030 with 512MB cache and a fully 
functional battery.  I couldn't find  any details about the internal 
RAID implementation used by Infortrend.   The array is SAS attached to 
an LSI HBA (SAS2008 PCI-Express Fusion-MPT SAS-2).

The system hardware is a SuperMicro quad 8-core XEON E7-4820 2.0GHz with 
128 GB of ram, hyper-theading enabled.  (This is something that I 
inherited.  There is no doubt that it is overkill.)
>>> >>  
Another bit of information that you didn't ask about is the I/O 
scheduler algorithm.  I just checked and found it set to 'cfq', although 
I though I had set it to 'noop' via a kernel parameter in GRUB.

Also, some observations about the cp -al:  In parallel to investigating 
hardware/OS/filesystem issue I have done some experiments with cp -al.  
It hurts to have 64 cores available and see cp -al running the wheels 
off just one, with a couple others slightly active with system level 
duties.  So I tried some experiments where I copied smaller segments of 
the file tree in parallel (using make -j).  I haven't had the chance to 
fully play this out, but these parallel cp invocations completed very 
quickly.  So it would appear that the cp command itself may bog down 
with such a large file tree.  I haven't had a chance to tear apart the 
source code or do any profiling to see if there are any obvious problems 
there.

Lastly, I will mention that I see almost 0% wa when watching top.

--------------000803040109070900050305
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
<pre class="moz-signature" cols="72">Dave Hall
Binghamton University
<a class="moz-txt-link-abbreviated" href="mailto:kdhall@binghamton.edu">kdhall@binghamton.edu</a>
607-760-2328 (Cell)
607-777-4641 (Office)</pre>
<br>
On 03/14/2013 08:55 AM, Stan Hoeppner wrote:
<blockquote cite="mid:5141C8C1.2080903@hardwarefreak.com" type="cite">
  <blockquote type="cite" style="color: rgb(0, 0, 0);">
    <pre wrap="">Yes,  please provide the output of the following commands:
    </pre>
  </blockquote>
  <pre wrap="">~$ uname -a
  </pre>
</blockquote>
<tt>Linux decoy 3.2.0-0.bpo.4-amd64 #1 SMP Debian 3.2.35-2~bpo60+1
x86_64 GNU/Linux</tt><br>
<blockquote cite="mid:5141C8C1.2080903@hardwarefreak.com" type="cite">
  <blockquote type="cite" style="color: rgb(0, 0, 0);">
    <pre wrap=""><span class="moz-txt-citetags">&gt; </span>~$ grep xfs /etc/fstab
    </pre>
  </blockquote>
</blockquote>
<tt>LABEL=backup&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; /infortrend&nbsp;&nbsp;&nbsp; xfs&nbsp;&nbsp;&nbsp;
inode64,noatime,nodiratime,nobarrier&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 0<br>
(cat /proc/mounts:&nbsp; /dev/sdb1 /infortrend xfs
rw,noatime,nodiratime,attr2,delaylog,nobarrier,inode64,noquota 0 0)</tt><br>
<br>
Note that there is also a second XFS on a separate 3ware raid card, but
the I/O traffic on that one is fairly low.&nbsp; It is used as a staging
area for a Debian mirror that is hosted on another server.<br>
<blockquote cite="mid:5141C8C1.2080903@hardwarefreak.com" type="cite">
  <blockquote type="cite" style="color: rgb(0, 0, 0);">
    <pre wrap=""><span class="moz-txt-citetags">&gt; </span>~$ xfs_info <i
 class="moz-txt-slash"><span class="moz-txt-tag">/</span>dev<span
 class="moz-txt-tag">/</span></i>[mount-point]
    </pre>
  </blockquote>
</blockquote>
<tt># xfs_info /dev/sdb1<br>
meta-data=/dev/sdb1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; isize=256&nbsp;&nbsp;&nbsp; agcount=26,
agsize=268435455 blks<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; attr=2<br>
data&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=6836364800,
imaxpct=5<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sunit=0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swidth=0 blks<br>
naming&nbsp;&nbsp; =version 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; ascii-ci=0<br>
log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =internal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=521728, version=2<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; sunit=0 blks, lazy-count=1<br>
realtime =none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; extsz=4096&nbsp;&nbsp; blocks=0, rtextents=0</tt><br>
<blockquote cite="mid:5141C8C1.2080903@hardwarefreak.com" type="cite">
  <blockquote type="cite" style="color: rgb(0, 0, 0);">
    <pre wrap=""><span class="moz-txt-citetags">&gt; </span>~$ df <i
 class="moz-txt-slash"><span class="moz-txt-tag">/</span>dev<span
 class="moz-txt-tag">/</span></i>[mount_point]
    </pre>
  </blockquote>
</blockquote>
<tt># df /dev/sdb1<br>
Filesystem&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1K-blocks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Used Available Use% Mounted on</tt><br>
/dev/sdb1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 27343372288 20432618356 6910753932&nbsp; 75% /infortrend<br>
<blockquote cite="mid:5141C8C1.2080903@hardwarefreak.com" type="cite">
  <blockquote type="cite" style="color: rgb(0, 0, 0);">
    <pre wrap=""><span class="moz-txt-citetags">&gt; </span>~$ df -i <i
 class="moz-txt-slash"><span class="moz-txt-tag">/</span>dev<span
 class="moz-txt-tag">/</span></i>[mount_point]
    </pre>
  </blockquote>
</blockquote>
<tt># df -i /dev/sdb1<br>
Filesystem&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Inodes&nbsp;&nbsp; IUsed&nbsp;&nbsp; IFree IUse% Mounted on<br>
/dev/sdb1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5469091840 1367746380 4101345460&nbsp;&nbsp; 26% /infortrend</tt><br>
<blockquote cite="mid:5141C8C1.2080903@hardwarefreak.com" type="cite">
  <blockquote type="cite" style="color: rgb(0, 0, 0);">
    <pre wrap=""><span class="moz-txt-citetags">&gt; </span>~$ xfs_db -r -c freesp <i
 class="moz-txt-slash"><span class="moz-txt-tag">/</span>dev<span
 class="moz-txt-tag">/</span></i>[mount-point]
    </pre>
  </blockquote>
</blockquote>
<tt># xfs_db -r -c freesp /dev/sdb1<br>
&nbsp;&nbsp; from&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; to extents&nbsp; blocks&nbsp;&nbsp;&nbsp; pct<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 832735&nbsp; 832735&nbsp;&nbsp; 0.05<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp; 432183 1037663&nbsp;&nbsp; 0.06<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp; 365573 1903965&nbsp;&nbsp; 0.11<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 15&nbsp; 352402 3891608&nbsp;&nbsp; 0.23<br>
&nbsp;&nbsp;&nbsp;&nbsp; 16&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 31&nbsp; 332762 7460486&nbsp;&nbsp; 0.43<br>
&nbsp;&nbsp;&nbsp;&nbsp; 32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 63&nbsp; 300571 13597941&nbsp;&nbsp; 0.79<br>
&nbsp;&nbsp;&nbsp;&nbsp; 64&nbsp;&nbsp;&nbsp;&nbsp; 127&nbsp; 233778 20900655&nbsp;&nbsp; 1.21<br>
&nbsp;&nbsp;&nbsp; 128&nbsp;&nbsp;&nbsp;&nbsp; 255&nbsp; 152003 27448751&nbsp;&nbsp; 1.59<br>
&nbsp;&nbsp;&nbsp; 256&nbsp;&nbsp;&nbsp;&nbsp; 511&nbsp; 112673 40941665&nbsp;&nbsp; 2.37<br>
&nbsp;&nbsp;&nbsp; 512&nbsp;&nbsp;&nbsp; 1023&nbsp;&nbsp; 82262 59331126&nbsp;&nbsp; 3.43<br>
&nbsp;&nbsp; 1024&nbsp;&nbsp;&nbsp; 2047&nbsp;&nbsp; 53238 76543454&nbsp;&nbsp; 4.43<br>
&nbsp;&nbsp; 2048&nbsp;&nbsp;&nbsp; 4095&nbsp;&nbsp; 34092 97842752&nbsp;&nbsp; 5.66<br>
&nbsp;&nbsp; 4096&nbsp;&nbsp;&nbsp; 8191&nbsp;&nbsp; 22743 129915842&nbsp;&nbsp; 7.52<br>
&nbsp;&nbsp; 8192&nbsp;&nbsp; 16383&nbsp;&nbsp; 14453 162422155&nbsp;&nbsp; 9.40<br>
&nbsp; 16384&nbsp;&nbsp; 32767&nbsp;&nbsp;&nbsp; 8501 190601554&nbsp; 11.03<br>
&nbsp; 32768&nbsp;&nbsp; 65535&nbsp;&nbsp;&nbsp; 4695 210822119&nbsp; 12.20<br>
&nbsp; 65536&nbsp; 131071&nbsp;&nbsp;&nbsp; 2615 234787546&nbsp; 13.59<br>
&nbsp;131072&nbsp; 262143&nbsp;&nbsp;&nbsp; 1354 237684818&nbsp; 13.76<br>
&nbsp;262144&nbsp; 524287&nbsp;&nbsp;&nbsp;&nbsp; 470 160228724&nbsp;&nbsp; 9.27<br>
&nbsp;524288 1048575&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 74 47384798&nbsp;&nbsp; 2.74<br>
1048576 2097151&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 2097122&nbsp;&nbsp; 0.12</tt><br>
<blockquote cite="mid:5141C8C1.2080903@hardwarefreak.com" type="cite">
  <blockquote type="cite" style="color: rgb(0, 0, 0);">
    <pre wrap=""><span class="moz-txt-citetags">&gt; </span>
<span class="moz-txt-citetags">&gt; </span>Also please provide the make/model of the RAID controller, the write
<span class="moz-txt-citetags">&gt; </span>cache size and if it is indeed enabled and working, as well as any
<span class="moz-txt-citetags">&gt; </span>errors, if any, logged by the controller in dmesg or elsewhere in Linux,
<span class="moz-txt-citetags">&gt; </span>or in the controller firmware.
<span class="moz-txt-citetags">&gt; </span>
    </pre>
  </blockquote>
</blockquote>
The RAID box is an Infortrend S16S-G1030 with 512MB cache and a fully
functional battery.&nbsp; I couldn't find&nbsp; any details about the internal
RAID implementation used by Infortrend. &nbsp; The array is SAS attached to
an LSI HBA (SAS2008 PCI-Express Fusion-MPT SAS-2).&nbsp; <br>
<br>
The system hardware is a SuperMicro quad 8-core XEON E7-4820 2.0GHz
with 128 GB of ram, hyper-theading enabled.&nbsp; (This is something that I
inherited.&nbsp; There is no doubt that it is overkill.)<br>
<blockquote cite="mid:5141C8C1.2080903@hardwarefreak.com" type="cite">
  <blockquote type="cite" style="color: rgb(0, 0, 0);">
    <blockquote type="cite" style="color: rgb(0, 0, 0);">
      <pre wrap=""><span class="moz-txt-citetags">&gt;&gt; </span></pre>
    </blockquote>
  </blockquote>
</blockquote>
Another bit of information that you didn't ask about is the I/O
scheduler algorithm.&nbsp; I just checked and found it set to 'cfq',
although I though I had set it to 'noop' via a kernel parameter in GRUB.<br>
<br>
Also, some observations about the cp -al:&nbsp; In parallel to investigating
hardware/OS/filesystem issue I have done some experiments with cp -al.&nbsp;
It hurts to have 64 cores available and see cp -al running the wheels
off just one, with a couple others slightly active with system level
duties.&nbsp; So I tried some experiments where I copied smaller segments of
the file tree in parallel (using make -j).&nbsp; I haven't had the chance to
fully play this out, but these parallel cp invocations completed very
quickly.&nbsp; So it would appear that the cp command itself may bog down
with such a large file tree.&nbsp; I haven't had a chance to tear apart the
source code or do any profiling to see if there are any obvious problems
there.<br>
<br>
Lastly, I will mention that I see almost 0% wa when watching top. <br>
</body>
</html>

--------------000803040109070900050305--


--===============1477873668588459734==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1477873668588459734==--
