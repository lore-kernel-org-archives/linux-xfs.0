Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D40B47F3F
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 12:48:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B3C1E304064
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 10:48:34 -0800 (PST)
Received: from nihrelayxway4.hub.nih.gov (nihrelayxway4.hub.nih.gov
	[128.231.90.98]) by cuda.sgi.com with ESMTP id mUgQopaD0RgagyHQ
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2014 10:48:33 -0800 (PST)
MIME-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: weird quota issue
From: "Weber, Charles (NIH/NIA/IRP) [C]" <weberc@grc.nia.nih.gov>
In-Reply-To: <20141223024248.GC4521@dastard>
Date: Tue, 23 Dec 2014 13:48:22 -0500
Message-ID: <F2C5AEA2-C54A-4AED-89D6-6909C28E7966@grc.nia.nih.gov>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<20141222204857.GK24183@dastard>
	<6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
	<20141222223540.GS15665@dastard>
	<2F3F57BB-59EA-4FF9-9254-6A598DE7AC46@grc.nia.nih.gov>
	<20141223003237.GA4521@dastard>
	<258BE536A650F646814BA46CC06568980F6A8AD7@msgb01.nih.gov>
	<20141223024248.GC4521@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7349609357969608526=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7349609357969608526==
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_9FAF1505-F3BB-4C99-8E2E-7609AF5A491F"

--Apple-Mail=_9FAF1505-F3BB-4C99-8E2E-7609AF5A491F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"


I had these errors running the trace-cmd report.
trace-cmd: No such file or directory
  function scsi_trace_parse_cdb not defined
  failed to read event print fmt for scsi_dispatch_cmd_start
  function scsi_trace_parse_cdb not defined
  failed to read event print fmt for scsi_dispatch_cmd_error
  function scsi_trace_parse_cdb not defined
  failed to read event print fmt for scsi_dispatch_cmd_done
  function scsi_trace_parse_cdb not defined
  failed to read event print fmt for scsi_dispatch_cmd_timeout
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_inotify_init
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_sync
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_vhangup
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_munlockall
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_getpgrp
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_setsid
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_restart_syscall
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_pause
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_getpid
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_getppid
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_getuid
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_geteuid
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_getgid
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_getegid
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_gettid
  Error: expected 'field' but read 'print'
  failed to read event format for sys_enter_sched_yield
> On Dec 22, 2014, at 9:42 PM, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Tue, Dec 23, 2014 at 02:12:15AM +0000, Weber, Charles (NIH/NIA/IRP) =
[E] wrote:
>> here you go
>>=20
>> # xfs_db -c "inode 131" -c p /dev/dm-7
>=20
> Nothing obviously wrong there, so there's no clear indication of why
> the quota initialisation failed. If hasn't got to quotacheck,
> because theat throws verbos errors when it fails, so it's something
> going wrong during initialisation.
>=20
> Just to narrow it down, if you mount with just uquota does the
> mount succeed? Please post the dmesg output whatever the outcome.
> Does mounting with just pquota succeed? If neither succeed, what
> happens if you mount with no quotas, then unmount and mount again
> with quotas enabled?
>=20
> If it still doesn't work, I'm going to need an event trace of a
> failed mount (install trace-cmd and run:
>=20
> # trace-cmd record -e xfs\* mount -o uquota,pquota /dev/dm-7 /mnt/pt
> <some output>
> # trace-cmd report > trace.out
>=20
> And then compress the trace.out file and attach it.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com


--Apple-Mail=_9FAF1505-F3BB-4C99-8E2E-7609AF5A491F
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_D5E978F5-824C-45C1-B5E0-DE4A4A082709"

--Apple-Mail=_D5E978F5-824C-45C1-B5E0-DE4A4A082709
Content-Transfer-Encoding: 7bit
Content-Type: text/html; charset="us-ascii"

<html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" class=""></body></html>
--Apple-Mail=_D5E978F5-824C-45C1-B5E0-DE4A4A082709
Content-Disposition: attachment; filename="trace-xfs.out.gz"
Content-Type: application/x-gzip; name="trace-xfs.out.gz"
Content-Transfer-Encoding: base64

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
jJfiuWr151JYmudq15+LzGg94Slzac9p+J5qwThzPWcCeo6fBl3Ecxk8xXNV688NN5ShnqtZfy7n
pXiuWv254cIv1HO168/5Dt9XUrv+nM9uK6B4rnr9OW8DvN56NfXncniK56rWn/Ougddba9afy3kp
nqtWfy7CwuuttevPRWa0/tyUubTn3HQT6NxTV73+nM9WACmeu5r6czk8xXNV68/FPgLXK6lZfy7y
ove32mr15yKsQz1Xu/5c/ILzudr151Jmmueq158L8RPquaupPxfh4fOtVevPhWaa8s95rmb9ucgL
53PV9glHWDifq71PODLD++dq7xNOmReyTzi0Bl6HuJp9wjn81e8TDm1aHeba9wlH3vGLZP+1Q095
77OvT9imGb6OkX/uH3lP+Ni/3r7t79Z3P/bU0CZnAN/2w68/1hdYqFmQD3bgc7HHP39TAHvoFkOb
mycirTNoSRjfyGBu/va8e+3JmKPX87gnYJjHXyAXwrz9YrDzMBthzFH+sO0f4s/G/8Q341s/7aQ8
0P/642/+9OHno48Wm5aUmsmy/pKa3d5tOLz8R4rNy0h0PJycHUTWtZBJudlle/DxrCYoq9Cj+GTW
NCubDzOYkUV2jR6vvR72bD52Wexw+YZrYkdnZcWeTUYSH5SHizfwXttHBkr0l2GGejopPisRkkBt
0UrM14F6/9wzUbkDuac3csYeVOgcyCo34sRAP+8pfOqf1+/Dkpsp6PrjQLp67u9/wWnHf8Nd/Bly
YwZvTE2scb8jSyN8PnT0S4sxNMg/76wW2WN3RRi5D5MkB4bBZEZb/O/gkvH216BMomIaMA4///YP
3/378DD86fZfh2/zuAwTMBzM4eeO//FEMePYZf/y3uDQMgf29JALhz38vuaG8vQA60w63uAkEjry
pvsDhMfziAsRnh4+XegvfCKB1C197xWR7sDstUium6OeynWlAgmktlo1lpraQngnps/pT7JWraJm
syS69ijd6GF8IWaFKR38FF+e7lPHG7Kk2592Ly8H3rS7dzrfkH/npwxj9z55uR95Yfo7P/1rfjO8
cW4//Pd3v+WlbrFRe0YiBTf2afy0S7sb/i98b+T+5Zv/B3tBs0o1iAEA
--Apple-Mail=_D5E978F5-824C-45C1-B5E0-DE4A4A082709
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="us-ascii"

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div class=3D"">I had these errors running the trace-cmd =
report.</div><div class=3D""><div style=3D"margin: 0px; font-size: 11px; =
font-family: Menlo; background-color: rgb(146, 146, 146);" =
class=3D"">trace-cmd: No such file or directory</div><div style=3D"margin:=
 0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; function scsi_trace_parse_cdb not =
defined</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event print fmt for scsi_dispatch_cmd_start</div><div =
style=3D"margin: 0px; font-size: 11px; font-family: Menlo; =
background-color: rgb(146, 146, 146);" class=3D"">&nbsp; function =
scsi_trace_parse_cdb not defined</div><div style=3D"margin: 0px; =
font-size: 11px; font-family: Menlo; background-color: rgb(146, 146, =
146);" class=3D"">&nbsp; failed to read event print fmt for =
scsi_dispatch_cmd_error</div><div style=3D"margin: 0px; font-size: 11px; =
font-family: Menlo; background-color: rgb(146, 146, 146);" =
class=3D"">&nbsp; function scsi_trace_parse_cdb not defined</div><div =
style=3D"margin: 0px; font-size: 11px; font-family: Menlo; =
background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed to read =
event print fmt for scsi_dispatch_cmd_done</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; function scsi_trace_parse_cdb not =
defined</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event print fmt for scsi_dispatch_cmd_timeout</div><div =
style=3D"margin: 0px; font-size: 11px; font-family: Menlo; =
background-color: rgb(146, 146, 146);" class=3D"">&nbsp; Error: expected =
'field' but read 'print'</div><div style=3D"margin: 0px; font-size: =
11px; font-family: Menlo; background-color: rgb(146, 146, 146);" =
class=3D"">&nbsp; failed to read event format for =
sys_enter_inotify_init</div><div style=3D"margin: 0px; font-size: 11px; =
font-family: Menlo; background-color: rgb(146, 146, 146);" =
class=3D"">&nbsp; Error: expected 'field' but read 'print'</div><div =
style=3D"margin: 0px; font-size: 11px; font-family: Menlo; =
background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed to read =
event format for sys_enter_sync</div><div style=3D"margin: 0px; =
font-size: 11px; font-family: Menlo; background-color: rgb(146, 146, =
146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_vhangup</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_munlockall</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_getpgrp</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_setsid</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_restart_syscall</div><div =
style=3D"margin: 0px; font-size: 11px; font-family: Menlo; =
background-color: rgb(146, 146, 146);" class=3D"">&nbsp; Error: expected =
'field' but read 'print'</div><div style=3D"margin: 0px; font-size: =
11px; font-family: Menlo; background-color: rgb(146, 146, 146);" =
class=3D"">&nbsp; failed to read event format for =
sys_enter_pause</div><div style=3D"margin: 0px; font-size: 11px; =
font-family: Menlo; background-color: rgb(146, 146, 146);" =
class=3D"">&nbsp; Error: expected 'field' but read 'print'</div><div =
style=3D"margin: 0px; font-size: 11px; font-family: Menlo; =
background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed to read =
event format for sys_enter_getpid</div><div style=3D"margin: 0px; =
font-size: 11px; font-family: Menlo; background-color: rgb(146, 146, =
146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_getppid</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_getuid</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_geteuid</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_getgid</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_getegid</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_gettid</div><div style=3D"margin: =
0px; font-size: 11px; font-family: Menlo; background-color: rgb(146, =
146, 146);" class=3D"">&nbsp; Error: expected 'field' but read =
'print'</div><div style=3D"margin: 0px; font-size: 11px; font-family: =
Menlo; background-color: rgb(146, 146, 146);" class=3D"">&nbsp; failed =
to read event format for sys_enter_sched_yield</div><div><blockquote =
type=3D"cite" class=3D""><div class=3D"">On Dec 22, 2014, at 9:42 PM, =
Dave Chinner &lt;<a href=3D"mailto:david@fromorbit.com" =
class=3D"">david@fromorbit.com</a>&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div class=3D"">On Tue, Dec 23, 2014 =
at 02:12:15AM +0000, Weber, Charles (NIH/NIA/IRP) [E] wrote:<br =
class=3D""><blockquote type=3D"cite" class=3D"">here you go<br =
class=3D""><br class=3D""># xfs_db -c "inode 131" -c p /dev/dm-7<br =
class=3D""></blockquote><br class=3D"">Nothing obviously wrong there, so =
there's no clear indication of why<br class=3D"">the quota =
initialisation failed. If hasn't got to quotacheck,<br class=3D"">because =
theat throws verbos errors when it fails, so it's something<br =
class=3D"">going wrong during initialisation.<br class=3D""><br =
class=3D"">Just to narrow it down, if you mount with just uquota does =
the<br class=3D"">mount succeed? Please post the dmesg output whatever =
the outcome.<br class=3D"">Does mounting with just pquota succeed? If =
neither succeed, what<br class=3D"">happens if you mount with no quotas, =
then unmount and mount again<br class=3D"">with quotas enabled?<br =
class=3D""><br class=3D"">If it still doesn't work, I'm going to need an =
event trace of a<br class=3D"">failed mount (install trace-cmd and =
run:<br class=3D""><br class=3D""># trace-cmd record -e xfs\* mount -o =
uquota,pquota /dev/dm-7 /mnt/pt<br class=3D"">&lt;some output&gt;<br =
class=3D""># trace-cmd report &gt; trace.out<br class=3D""><br =
class=3D"">And then compress the trace.out file and attach it.<br =
class=3D""><br class=3D"">Cheers,<br class=3D""><br class=3D"">Dave.<br =
class=3D"">-- <br class=3D"">Dave Chinner<br class=3D""><a =
href=3D"mailto:david@fromorbit.com" class=3D"">david@fromorbit.com</a><br =
class=3D""></div></blockquote></div><br class=3D""></div></body></html>=

--Apple-Mail=_D5E978F5-824C-45C1-B5E0-DE4A4A082709--

--Apple-Mail=_9FAF1505-F3BB-4C99-8E2E-7609AF5A491F--


--===============7349609357969608526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7349609357969608526==--
