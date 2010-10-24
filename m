Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9O2wom9086066 for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 21:58:50 -0500
Received: from mail.sotech1.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 401601972E16
	for <xfs@oss.sgi.com>; Sat, 23 Oct 2010 19:59:56 -0700 (PDT)
Received: from mail.sotech1.com (sl-speci32-137461-0.sprintlink.net
	[144.232.190.126]) by cuda.sgi.com with ESMTP id
	oTGLSyBPkhUsKOsm for <xfs@oss.sgi.com>;
	Sat, 23 Oct 2010 19:59:56 -0700 (PDT)
From: Andrew Debenham <adebenham@sotech1.com>
Date: Sat, 23 Oct 2010 22:59:58 -0400
Subject: XFS Test Results Interpretation
Message-ID: <3C5E029826A0704DB5998577FCFF46F0095A278CBF@dagobah>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7986468891762001032=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7986468891762001032==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_3C5E029826A0704DB5998577FCFF46F0095A278CBFdagobah_"

--_000_3C5E029826A0704DB5998577FCFF46F0095A278CBFdagobah_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello -

I am in the process of trying to determine the best parameters to use when =
creating and mounting an XFS file system on some new hardware we are going =
to be using.  My company has two separate applications that will be running=
 on the same hardware (but on separate systems).  One application is the Po=
stgreSQL database and the other is a custom application that does writes to=
 many (~1,000) relatively small (~672MB) files concurrently.

I decided to use Bonnie++ to test a 17TB XFS file system, varying the mkfs.=
xfs and the mount parameters, in order to determine the optimal settings fo=
r our new systems.  I originally tried attaching my spreadsheet to this ema=
il, but I'm guessing your server doesn't accept attachments.  So, I've inse=
rted my results as a table below; hopefully it will come through in a somew=
hat readable format.  If not, please send me your email and I'll forward yo=
u the original spreadsheet.  For each set of parameters, I ran Bonnie++ 3 s=
eparate times and took the average of the results.

Also, a couple of things to note.  First, we are already locked into this v=
ersion of CentOS and the current kernel, so even though they are a bit date=
d, we will not be able to upgrade to the latest kernel.  Also, here are the=
 release and version numbers of the XFS packages currently installed on the=
se systems:
kmod-xfs-0.4-2
xfsprogs-devel-2.9.4-1.el5.centos

When I started specifying the sunit and swidth parameters, I expected to se=
e the sequential block input and output to improve, but my final results di=
dn't really show this (maybe my expectations were just wrong?).  I was hopi=
ng that someone with a lot more XFS expertise could take a look at my resul=
ts and interpret them for me?  Do my test results look accurate or is it po=
ssible that I setup my test incorrectly?  Based on the two applications tha=
t will be using an XFS file system, is there an optimal set of parameters t=
hat I can use for one or both applications?  Any suggestions or recommendat=
ions would be greatly appreciated.  Thanks in advance for your help in this=
 matter.

- Andrew



Data

Sequential Output

Sequential Input

Random Seeks

Sequential Create

Random Create

Number of Files

mkfs.xfs Options

Mount Options

Chunk Size

Per Char

Block

Rewrite

Per Char

Block

Create

Read

Delete

Create

Read

Delete

K/sec

%CP

K/sec

%CP

K/sec

%CP

K/sec

%CP

K/sec

%CP

/sec

%CP

/sec

%CP

/sec

%CP

/sec

%CP

/sec

%CP

/sec

%CP

/sec

%CP

64352M

94013

99

472221

50

85811

11

80600

92

221248

14

377.6

0

2814

70

8036

92.7

12635

93.3

2924

71.7

7927

92.3

9819

80.7

10:688128:5120:1

-l size=3D16384b

rw

64352M

95284

99

450426

47.7

78142

10

74617

86.7

187983

12.3

341.7

0

2488

63

8672

99

11862

93

2669

67.3

7251

83

11165

87

10:688128:5120:1

-l size=3D16384b

rw,noatime,nodiratime,logbufs=3D8

64352M

90512

99

494516

51.3

84420

10.7

78464

89.7

207651

12

379.5

0.33

2694

64

9000

99

12772

97.3

3059

71

8480

93.3

10178

81.3

10:688128:5120:1

-l size=3D16384b

rw,noatime,nodiratime,logbufs=3D8,nobarrier

64352M

88295

99

501854

53

89128

11

80788

92.3

230101

16.7

368.4

0

3196

80.3

8552

98.3

12818

94.7

2693

64.3

7189

83.7

11396

90

10:688128:5120:1

-l size=3D128m

rw

64352M

91501

99

487799

51.3

91343

11.3

83336

95

236927

17

379.7

0

2852

72

8394

96.7

12879

95.7

2865

68

7957

91.3

11540

88

10:688128:5120:1

-l size=3D128m

rw,noatime,nodiratime,logbufs=3D8

64352M

96319

99

453202

47

82270

10.3

78626

89.3

204320

12.3

377.1

0.33

2948

70.7

8905

97.7

13072

97.7

3004

69.7

8324

92.3

12029

97.3

10:688128:5120:1

-l size=3D128m

rw,noatime,nodiratime,logbufs=3D8,nobarrier

64352M

92101

99

477882

50

90622

11

82742

94.7

239307

14.7

377.0

0

2800

69.3

8954

99

11597

85.3

2699

64.3

8836

100

10299

83.7

10:688128:5120:1

-l version=3D2,size=3D16384b

rw

64352M

98567

99

448664

46.7

81706

10

78214

90

217844

16

362.0

0

2529

64

8899

98

12754

95.7

2988

69

8419

93.3

9267

72.7

10:688128:5120:1

-l version=3D2,size=3D16384b

rw,noatime,nodiratime,logbufs=3D8

64352M

92854

99

482572

50.7

79940

9.67

76456

88.3

193196

14.3

344.5

0

2782

68

8925

99.3

12953

98.3

2904

67.7

8272

93.3

10709

86.7

10:688128:5120:1

-l version=3D2,size=3D16384b

rw,noatime,nodiratime,logbufs=3D8,nobarrier

64352M

96836

99

482944

51

92771

12

82157

94

240734

14

383.0

0.67

3176

79.3

8419

97

12932

96

2925

70.3

8572

99

11595

88.3

10:688128:5120:1

-l version=3D2,size=3D128m

rw

64352M

96595

99

493446

51.3

82685

10.3

78582

89.7

214803

12.7

366.2

0.33

3644

86.7

8805

99

13503

98.3

3316

77.3

7564

87

9005

69.3

10:688128:5120:1

-l version=3D2,size=3D128m

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k

64352M

94856

99

516368

54

79747

10

75690

87.3

198909

13.7

352.6

0

3680

86.3

8800

99

13825

98.7

3652

85.3

7952

90.3

10891

85

10:688128:5120:1

-l version=3D2,size=3D128m

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,nobarrier

64352M

90933

99

463918

48.7

81266

10.3

76380

88.3

229959

14

372.3

0.33

2704

67.7

8670

99.3

12473

96.3

2878

70

8572

97.7

9065

70

10:688128:5120:1

-l version=3D2,size=3D16384b -i attr=3D2

rw

64352M

89084

99

459402

49

80776

10.3

75495

86.7

230625

12.7

371.6

0.33

3173

74.7

7410

83.3

13247

96.7

4017

93.3

7778

87.3

10813

82.3

10:688128:5120:1

-l version=3D2,size=3D16384b -i attr=3D2

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k

64352M

92994

99

486561

51.7

78986

9.67

76097

87.7

230976

12

379.1

0.33

3652

85.3

7255

81.7

11593

83.3

3941

90.7

8964

98.7

9354

71.7

10:688128:5120:1

-l version=3D2,size=3D16384b -i attr=3D2

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,nobarrier

64352M

89910

99

508021

53.3

81036

10

78428

90

214695

16.3

362.2

0

2891

72.3

8658

99.3

12888

95

2833

69

7999

93

11380

84.7

10:688128:5120:1

-l version=3D2,size=3D128m -i attr=3D2

rw

64352M

96944

99

487031

51

91412

11.3

82028

93.3

235545

14.3

374.9

0

3589

84.7

8579

99

13744

99

3622

84.3

7983

91

10703

82

10:688128:5120:1

-l version=3D2,size=3D128m -i attr=3D2

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k

64352M

92401

99

490172

51.7

78263

9.67

77018

88.7

235954

14.3

382.6

0.33

3612

84.3

8754

99

12172

89

3414

82.7

6170

71.3

9253

80.3

10:688128:5120:1

-l version=3D2,size=3D128m -i attr=3D2

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,nobarrier

64352M

91268

99

464753

49.3

66828

8

67592

81

125015

10

362.6

0

2745

66.3

8755

99

9344

74.3

3198

73.7

7310

85

7252

60

10:688128:5120:1

-l version=3D2,size=3D16384b -d su=3D262144,sw=3D9

rw

64352M

95877

99

435503

46

60831

7

67252

80.3

125840

10

361.2

0

3044

75

8688

99.7

5479

53.3

3013

70.7

7009

81.3

11294

86.7

10:688128:5120:1

-l version=3D2,size=3D16384b -d su=3D262144,sw=3D9

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k

64352M

95787

99

481562

51

90843

11.3

82987

94.7

240849

13

378.4

0

3249

75.3

8124

89.7

9918

83.7

3582

85.3

7283

82.7

6402

50.3

10:688128:5120:1

-l version=3D2,size=3D16384b -d su=3D262144,sw=3D9

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,nobarrier

64352M

88591

99

475663

50.7

83011

10.3

77000

89

220378

14

362.7

0

4197

97

8659

99.3

6089

47.3

3121

76

6257

71.3

10488

79.7

10:688128:5120:1

-l version=3D2,size=3D128m -d su=3D262144,sw=3D9

rw

64352M

91727

99

465144

49

80260

10

77585

89.7

233708

14.7

368.1

0

3739

87

8507

99.7

5478

42.7

3396

78.7

8602

94

8534

64.7

10:688128:5120:1

-l version=3D2,size=3D128m -d su=3D262144,sw=3D9

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k

64352M

95867

99

464367

49.3

80796

10

75411

87.7

218984

17

370.1

0

3671

87

8658

99

5500

50.7

3530

82.7

7536

85

8368

66.7

10:688128:5120:1

-l version=3D2,size=3D128m -d su=3D262144,sw=3D9

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,nobarrier

64352M

98446

99

459868

48.3

78259

10

76096

88

226517

16

365.3

0

3281

76.7

6440

73

6267

47.3

2992

69.7

7664

89.3

7732

60.7

10:688128:5120:1

-l version=3D2,size=3D16384b -i attr=3D2 -d su=3D262144,sw=3D9

rw

64352M

91304

99

442525

47.3

82323

10.3

76163

88

229872

15.7

380.9

0

3015

71

7284

80.7

11545

89.3

3737

88

4466

50

9422

71

10:688128:5120:1

-l version=3D2,size=3D16384b -i attr=3D2 -d su=3D262144,sw=3D9

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k

64352M

92167

99

396332

42

81941

10.3

76401

88

233618

15.7

382.5

0

3626

86.7

6662

75.3

11444

84

4003

91.7

8074

92.3

4023

31.7

10:688128:5120:1

-l version=3D2,size=3D16384b -i attr=3D2 -d su=3D262144,sw=3D9

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,nobarrier

64352M

92294

99

479220

50.3

81340

10.3

77236

89

235145

14.7

372.3

0.33

3854

89.7

8452

99

5212

43

3518

87

5118

60.7

12679

95

10:688128:5120:1

-l version=3D2,size=3D128m -i attr=3D2 -d su=3D262144,sw=3D9

rw

64352M

95706

99

471999

49.7

82204

10.3

77009

88.7

225017

16.3

368.1

0

3740

88

8535

99.3

6571

49.7

3826

88.3

4362

49.7

11466

86.7

10:688128:5120:1

-l version=3D2,size=3D128m -i attr=3D2 -d su=3D262144,sw=3D9

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k

64352M

96086

99

407269

43

82465

10

75962

88

236212

16.7

372.6

0.33

3793

88.3

8828

99.3

5416

45.3

4103

94.3

7496

85

8085

65

10:688128:5120:1

-l version=3D2,size=3D128m -i attr=3D2 -d su=3D262144,sw=3D9

rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,nobarrier


MAX:

98567

99

516368

54

92771

12

83336

95

240849

17

383.0

0.67

4197

97

9000

99.7

13825

99

4103

94.3

8964

100

12679

97.3

MIN:

88295

99

396332

42

60831

7

67252

80.3

125015

10

341.7

0

2488

63

6440

73

5212

42.7

2669

64.3

4362

49.7

4023

31.7

AVG:

93504

99

470040

49.5

82048

10.2

77414

89.2

217398

14.2

369.9

0.12

3239

77.7

8376

95

10599

80.5

3281

77.4

7513

85.5

9807

76.6

MED:

92924

99

473942

50

81824

10.3

77014

88.8

228195

14.3

372.0

0

3186

76

8658

99

12017

91.2

3160

74.8

7853

89.8

10239

81


Controller

RAID

# Disks

Stripe Size

Type

Disk Size

FS Size

OS

Kernel

Motherboard

Chipset

RAM

Processors

3ware 9650SE-12M

6

11

256 KB

SATA

1.82 TB

17 TB

CentOS 5.3

2.6.18-128.el5

Supermicro X8DTU

Intel 5520 (Tylersburg)

32GB PC3-8500 1066MHz

Dual Intel Xeon E5540 @2.53GHz





________________________________
This email and any attachments may be confidential and are intended solely =
for the use of the individual to whom it is addressed.

If you are not the intended recipient of this email, the following stipulat=
ions govern the use of this information: You may not take any action based =
upon its contents. You may not copy or show this message or attachments to =
anyone. You should contact the sender and subsequently delete this message =
and all attachments.

Any views or opinions expressed are solely those of the author and do not n=
ecessarily represent those of Special Operations Technology, Incorporated.

While antivirus software has been applied, you should perform due diligence=
 to check this email and attachments for the presence of viruses. No warran=
ties or assurances are made in relation to the safety and content of this e=
mail and attachments. Special Operations Technology, Incorporated accepts n=
o liability for any damages caused by any virus transmitted by or contained=
 in this email and attachments.

No liability is accepted for any consequences arising from this email trans=
mission whatsoever.

Special Operations Technology, Incorporated is a premier IT professional se=
rvices firm focused in the government and law enforcement space.

--_000_3C5E029826A0704DB5998577FCFF46F0095A278CBFdagobah_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p
	{mso-style-priority:99;
	margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman","serif";}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D">Hello -<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D">I am in the process of tr=
ying to determine the best parameters to use when creating and mounting an =
XFS file system on some new hardware we are going to be
 using.&nbsp; My company has two separate applications that will be running=
 on the same hardware (but on separate systems).&nbsp; One application is t=
he PostgreSQL database and the other is a custom application that does writ=
es to many (~1,000) relatively small (~672MB)
 files concurrently.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D">I decided to use Bonnie&#=
43;&#43; to test a 17TB XFS file system, varying the mkfs.xfs and the mount=
 parameters, in order to determine the optimal settings for our
 new systems.&nbsp; </span><span style=3D"font-size:11.0pt;font-family:&quo=
t;Calibri&quot;,&quot;sans-serif&quot;;color:#1F497D">I originally tried at=
taching my spreadsheet to this email, but I&#8217;m guessing your server do=
esn&#8217;t accept attachments.&nbsp; So,
</span><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,&quo=
t;sans-serif&quot;;color:#1F497D">I&#8217;ve
</span><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,&quo=
t;sans-serif&quot;;color:#1F497D">inserted my results as a table below; hop=
efully it will come through in a somewhat readable format</span><span style=
=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;=
;color:#1F497D">.&nbsp;
</span><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,&quo=
t;sans-serif&quot;;color:#1F497D">If not, please send me your email and I&#=
8217;ll forward you the original spreadsheet.&nbsp;
</span><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,&quo=
t;sans-serif&quot;;color:#1F497D">For each set of parameters, I ran Bonnie&=
#43;&#43; 3 separate times and took the average of the results.<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D">Also, a couple of things =
to note.&nbsp; First, we are already locked into this version of CentOS and=
 the current kernel, so even though they are a bit dated, we
 will not be able to upgrade to the latest kernel.&nbsp; Also, here are the=
 release and version numbers of the XFS packages currently installed on the=
se systems:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D">kmod-xfs-0.4-2<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D">xfsprogs-devel-2.9.4-1.el=
5.centos<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D">When I started specifying=
 the sunit and swidth parameters, I expected to see the sequential block in=
put and output to improve, but my final results didn&#8217;t really
 show this</span><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&=
quot;,&quot;sans-serif&quot;;color:#1F497D"> (maybe my expectations were ju=
st wrong?)</span><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&=
quot;,&quot;sans-serif&quot;;color:#1F497D">.&nbsp; I was hoping that someo=
ne with</span><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quo=
t;,&quot;sans-serif&quot;;color:#1F497D">
 a lot more</span><span style=3D"font-size:11.0pt;font-family:&quot;Calibri=
&quot;,&quot;sans-serif&quot;;color:#1F497D"> XFS expertise could take a lo=
ok at my results and interpret them for me?&nbsp; Do my test results look a=
ccurate or is it possible that I setup my test incorrectly?&nbsp;
 Based on the two applications that will be using an XFS file system, is th=
ere an optimal set of parameters that I can use for one or both application=
s?&nbsp; Any suggestions or recommendations would be greatly appreciated.&n=
bsp; Thanks in advance for your help in this
 matter.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D">- Andrew
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span><=
/p>
<p class=3D"MsoNormal">&nbsp;&nbsp; <o:p></o:p></p>
<div align=3D"center">
<table class=3D"MsoNormalTable" border=3D"1" cellspacing=3D"0" cellpadding=
=3D"0" width=3D"1610" style=3D"width:1207.5pt;border-collapse:collapse;bord=
er:none">
<tbody>
<tr style=3D"height:32.25pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;paddin=
g:0in 0in 0in 0in;height:32.25pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center"><a name=
=3D"RANGE!A1:AB42">Data</a><o:p></o:p></p>
</td>
<td width=3D"292" colspan=3D"6" style=3D"width:219.0pt;border:solid windowt=
ext 1.0pt;border-left:none;padding:0in 0in 0in 0in;height:32.25pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Sequent=
ial Output<o:p></o:p></p>
</td>
<td width=3D"147" colspan=3D"4" style=3D"width:110.0pt;border:solid windowt=
ext 1.0pt;border-left:none;padding:0in 0in 0in 0in;height:32.25pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Sequent=
ial Input<o:p></o:p></p>
</td>
<td width=3D"65" colspan=3D"2" rowspan=3D"2" style=3D"width:49.0pt;border:s=
olid windowtext 1.0pt;border-left:none;padding:0in 0in 0in 0in;height:32.25=
pt">
<p class=3D"MsoNormal">Random Seeks<o:p></o:p></p>
</td>
<td width=3D"192" colspan=3D"6" style=3D"width:2.0in;border:solid windowtex=
t 1.0pt;border-left:none;padding:0in 0in 0in 0in;height:32.25pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Sequent=
ial Create<o:p></o:p></p>
</td>
<td width=3D"192" colspan=3D"6" style=3D"width:2.0in;border:solid windowtex=
t 1.0pt;border-left:none;padding:0in 0in 0in 0in;height:32.25pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Random =
Create<o:p></o:p></p>
</td>
<td width=3D"117" rowspan=3D"3" style=3D"width:87.5pt;border:solid windowte=
xt 1.0pt;border-left:none;padding:0in 0in 0in 0in;height:32.25pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Number =
of Files<o:p></o:p></p>
</td>
<td width=3D"177" rowspan=3D"3" style=3D"width:133.0pt;border:solid windowt=
ext 1.0pt;border-left:none;padding:0in 0in 0in 0in;height:32.25pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">mkfs.xf=
s Options<o:p></o:p></p>
</td>
<td width=3D"344" rowspan=3D"3" style=3D"width:258.0pt;border:solid windowt=
ext 1.0pt;border-left:none;padding:0in 0in 0in 0in;height:32.25pt">
<p class=3D"MsoNormal">Mount Options<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" rowspan=3D"2" style=3D"width:63.0pt;border:solid windowtex=
t 1.0pt;border-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Chunk S=
ize<o:p></o:p></p>
</td>
<td width=3D"145" colspan=3D"2" style=3D"width:109.0pt;border-top:none;bord=
er-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid window=
text 1.0pt;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Per Cha=
r<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Block<o=
:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Rewrite=
<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Per Cha=
r<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Block<o=
:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Create<=
o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Read<o:=
p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Delete<=
o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Create<=
o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Read<o:=
p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Delete<=
o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">K/sec<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">K/sec<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">K/sec<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">K/sec<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">K/sec<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">/sec<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">/sec<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">/sec<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">/sec<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">/sec<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">/sec<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">/sec<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">%CP<o:p=
></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94013<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">472221<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85811<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80600<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">221248<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">377.6<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2814<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">70<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8036<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12635<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2924<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">71.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7927<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9819<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l size=3D16384b<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95284<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">450426<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">47.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78142<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">74617<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">86.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">187983<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">341.7<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2488<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">63<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8672<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11862<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2669<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">67.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7251<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11165<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l size=3D16384b<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90512<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">494516<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">51.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">84420<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78464<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">207651<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">379.5<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2694<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9000<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12772<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3059<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">71<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8480<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10178<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l size=3D16384b<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,nobarrier<o:p></o:=
p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88295<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">501854<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">53<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89128<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80788<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">230101<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">16.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">368.4<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3196<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8552<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12818<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2693<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7189<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11396<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l size=3D128m<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center"><a name=
=3D"RANGE!A8:Y20">64352M</a><o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91501<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">487799<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">51.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91343<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83336<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">236927<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">17<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">379.7<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2852<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">72<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8394<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12879<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2865<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">68<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7957<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11540<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l size=3D128m<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96319<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">453202<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">47<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82270<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78626<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">204320<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">377.1<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2948<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">70.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8905<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">13072<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3004<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">69.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8324<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12029<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l size=3D128m<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,nobarrier<o:p></o:=
p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92101<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">477882<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90622<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82742<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">239307<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">377.0<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2800<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">69.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8954<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11597<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2699<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8836<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">100<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10299<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98567<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">448664<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">46.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81706<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78214<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">217844<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">16<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">362.0<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2529<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8899<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12754<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2988<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">69<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8419<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9267<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">72.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92854<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">482572<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">79940<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9.67<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76456<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">193196<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">344.5<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2782<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">68<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8925<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12953<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2904<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">67.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8272<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10709<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">86.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,nobarrier<o:p></o:=
p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96836<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">482944<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">51<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92771<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82157<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">240734<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">383.0<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.67<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3176<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">79.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8419<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12932<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2925<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">70.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8572<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11595<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96595<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">493446<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">51.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82685<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78582<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">214803<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">366.2<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3644<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">86.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8805<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">13503<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3316<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7564<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9005<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">69.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k<o:=
p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94856<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">516368<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">54<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">79747<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">75690<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">198909<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">13.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">352.6<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3680<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">86.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8800<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">13825<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3652<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7952<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10891<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,no=
barrier<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90933<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">463918<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">48.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81266<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76380<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">229959<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">372.3<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2704<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">67.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8670<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12473<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2878<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">70<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8572<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9065<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">70<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -i attr=3D2<o:p></o:p><=
/p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89084<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">459402<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80776<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">75495<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">86.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">230625<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">371.6<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3173<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">74.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7410<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">13247<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4017<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7778<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10813<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -i attr=3D2<o:p></o:p><=
/p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k<o:=
p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92994<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">486561<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">51.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78986<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9.67<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76097<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">230976<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">379.1<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3652<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7255<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11593<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3941<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8964<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9354<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">71.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -i attr=3D2<o:p></o:p><=
/p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,no=
barrier<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89910<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">508021<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">53.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81036<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78428<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">214695<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">16.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">362.2<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2891<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">72.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8658<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12888<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2833<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">69<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7999<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11380<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">84.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -i attr=3D2<o:p></o:p></p=
>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96944<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">487031<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">51<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91412<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82028<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">235545<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">374.9<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3589<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">84.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8579<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">13744<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3622<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">84.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7983<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10703<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -i attr=3D2<o:p></o:p></p=
>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k<o:=
p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92401<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">490172<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">51.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78263<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9.67<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77018<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">235954<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">382.6<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3612<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">84.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8754<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12172<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3414<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6170<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">71.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9253<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -i attr=3D2<o:p></o:p></p=
>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,no=
barrier<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91268<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">464753<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">66828<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">67592<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">125015<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">362.6<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2745<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">66.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8755<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9344<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">74.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3198<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">73.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7310<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7252<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">60<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -d su=3D262144,sw=3D9<o=
:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95877<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">435503<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">46<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">60831<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">67252<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">125840<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">361.2<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3044<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">75<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8688<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">5479<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">53.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3013<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">70.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7009<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11294<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">86.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -d su=3D262144,sw=3D9<o=
:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k<o:=
p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95787<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">481562<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">51<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">90843<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82987<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">240849<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">13<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">378.4<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3249<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">75.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8124<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9918<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3582<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7283<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6402<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -d su=3D262144,sw=3D9<o=
:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,no=
barrier<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88591<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">475663<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83011<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77000<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">220378<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">362.7<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4197<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8659<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6089<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">47.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3121<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6257<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">71.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10488<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">79.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -d su=3D262144,sw=3D9<o:p=
></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91727<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">465144<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80260<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77585<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">233708<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">368.1<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3739<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8507<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">5478<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">42.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3396<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8602<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8534<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -d su=3D262144,sw=3D9<o:p=
></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k<o:=
p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95867<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">464367<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80796<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">75411<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">218984<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">17<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">370.1<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3671<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8658<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">5500<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3530<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7536<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8368<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">66.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -d su=3D262144,sw=3D9<o:p=
></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,no=
barrier<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98446<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">459868<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">48.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">78259<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76096<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">226517<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">16<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">365.3<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3281<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6440<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">73<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6267<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">47.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2992<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">69.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7664<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7732<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">60.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -i attr=3D2 -d su=3D262=
144,sw=3D9<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91304<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">442525<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">47.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82323<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76163<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">229872<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">15.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">380.9<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3015<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">71<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7284<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11545<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3737<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4466<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9422<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">71<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -i attr=3D2 -d su=3D262=
144,sw=3D9<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k<o:=
p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92167<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">396332<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">42<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81941<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76401<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">233618<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">15.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">382.5<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3626<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">86.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6662<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">75.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11444<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">84<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4003<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8074<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4023<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">31.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D16384b -i attr=3D2 -d su=3D262=
144,sw=3D9<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,no=
barrier<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92294<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">479220<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81340<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77236<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">235145<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">372.3<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3854<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8452<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">5212<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">43<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3518<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">87<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">5118<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">60.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12679<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -i attr=3D2 -d su=3D26214=
4,sw=3D9<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95706<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">471999<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82204<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77009<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">225017<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">16.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">368.1<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3740<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8535<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6571<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3826<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4362<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11466<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">86.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -i attr=3D2 -d su=3D26214=
4,sw=3D9<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k<o:=
p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64352M<=
o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">96086<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">407269<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">43<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82465<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">75962<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">236212<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">16.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">372.6<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.33<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3793<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8828<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">5416<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">45.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4103<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7496<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8085<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">65<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10:6881=
28:5120:1<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">-l version=3D2,size=3D128m -i attr=3D2 -d su=3D26214=
4,sw=3D9<o:p></o:p></p>
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">rw,noatime,nodiratime,logbufs=3D8,logbsize=3D256k,no=
barrier<o:p></o:p></p>
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">MAX:<o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">98567<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">516368<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">54<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92771<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">83336<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">240849<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">17<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">383.0<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.67<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4197<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9000<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">13825<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4103<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">94.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8964<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">100<o:p=
></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12679<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">97.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">MIN:<o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88295<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">396332<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">42<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">60831<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">67252<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">125015<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">341.7<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2488<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">63<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6440<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">73<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">5212<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">42.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2669<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">64.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4362<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">4023<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">31.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">AVG:<o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">93504<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">470040<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">49.5<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">82048<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.2<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77414<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.2<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">217398<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14.2<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">369.9<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0.12<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3239<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77.7<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8376<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">95<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10599<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">80.5<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3281<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77.4<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7513<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">85.5<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">9807<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76.6<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">MED:<o:p></o:p></p>
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">92924<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">473942<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">50<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81824<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">77014<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">88.8<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">228195<=
o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">14.3<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">372.0<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">0<o:p><=
/o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3186<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">76<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">8658<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">99<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">12017<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">91.2<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">3160<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">74.8<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">7853<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">89.8<o:=
p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">10239<o=
:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">81<o:p>=
</o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr style=3D"height:15.0pt">
<td colspan=3D"2" style=3D"border:solid windowtext 1.0pt;border-top:none;pa=
dding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal">Controller<o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal">RAID<o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal"># Disks<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">Stripe Size<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">Type<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">Disk Size<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">FS Size<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">OS<o:p></o:p></p>
</td>
<td colspan=3D"3" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">Kernel<o:p></o:p></p>
</td>
<td colspan=3D"3" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">Motherboard<o:p></o:p></p>
</td>
<td colspan=3D"3" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">Chipset<o:p></o:p></p>
</td>
<td colspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal">RAM<o:p></o:p></p>
</td>
<td style=3D"border-top:none;border-left:none;border-bottom:solid windowtex=
t 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:=
15.0pt">
<p class=3D"MsoNormal">Processors<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"188" colspan=3D"2" rowspan=3D"2" style=3D"width:140.75pt;borde=
r:solid windowtext 1.0pt;border-top:none;padding:0in 0in 0in 0in;height:15.=
0pt">
<p class=3D"MsoNormal">3ware 9650SE-12M&nbsp;<o:p></o:p></p>
</td>
<td rowspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">6<o:p><=
/o:p></p>
</td>
<td rowspan=3D"2" style=3D"border-top:none;border-left:none;border-bottom:s=
olid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padding:0in 0in 0=
in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">11<o:p>=
</o:p></p>
</td>
<td width=3D"69" colspan=3D"2" rowspan=3D"2" style=3D"width:52.0pt;border-t=
op:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:=
solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">256 KB<=
o:p></o:p></p>
</td>
<td colspan=3D"2" rowspan=3D"2" style=3D"border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">SATA<o:=
p></o:p></p>
</td>
<td colspan=3D"2" rowspan=3D"2" style=3D"border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">1.82 TB=
<o:p></o:p></p>
</td>
<td colspan=3D"2" rowspan=3D"2" style=3D"border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">17 TB<o=
:p></o:p></p>
</td>
<td colspan=3D"2" rowspan=3D"2" style=3D"border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">CentOS =
5.3<o:p></o:p></p>
</td>
<td colspan=3D"3" rowspan=3D"2" style=3D"border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">2.6.18-=
128.el5<o:p></o:p></p>
</td>
<td width=3D"102" colspan=3D"3" rowspan=3D"2" style=3D"width:76.5pt;border-=
top:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right=
:solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Supermi=
cro X8DTU<o:p></o:p></p>
</td>
<td width=3D"90" colspan=3D"3" rowspan=3D"2" style=3D"width:67.5pt;border-t=
op:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:=
solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Intel 5=
520 (Tylersburg)<o:p></o:p></p>
</td>
<td width=3D"69" colspan=3D"2" rowspan=3D"2" style=3D"width:52.0pt;border-t=
op:none;border-left:none;border-bottom:solid windowtext 1.0pt;border-right:=
solid windowtext 1.0pt;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">32GB PC=
3-8500 1066MHz<o:p></o:p></p>
</td>
<td width=3D"117" rowspan=3D"2" style=3D"width:87.5pt;border-top:none;borde=
r-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowt=
ext 1.0pt;padding:0in 0in 0in 0in;height:15.0pt">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center">Dual In=
tel Xeon E5540 @2.53GHz<o:p></o:p></p>
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr style=3D"height:15.0pt">
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in;height:15.0pt">
</td>
</tr>
<tr>
<td width=3D"84" style=3D"width:63.0pt;border:solid windowtext 1.0pt;border=
-top:none;padding:0in 0in 0in 0in">
</td>
<td width=3D"104" style=3D"width:77.75pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in">
</td>
<td width=3D"42" style=3D"width:31.25pt;border-top:none;border-left:none;bo=
rder-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padd=
ing:0in 0in 0in 0in">
</td>
<td width=3D"49" style=3D"width:36.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"41" style=3D"width:30.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"41" style=3D"width:30.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"49" style=3D"width:36.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"37" style=3D"width:27.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"33" style=3D"width:24.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"33" style=3D"width:24.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"41" style=3D"width:30.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"33" style=3D"width:24.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"33" style=3D"width:24.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"41" style=3D"width:30.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"29" style=3D"width:21.5pt;border-top:none;border-left:none;bor=
der-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;paddi=
ng:0in 0in 0in 0in">
</td>
<td width=3D"117" style=3D"width:87.5pt;border-top:none;border-left:none;bo=
rder-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;padd=
ing:0in 0in 0in 0in">
</td>
<td width=3D"177" style=3D"width:133.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in">
</td>
<td width=3D"344" style=3D"width:258.0pt;border-top:none;border-left:none;b=
order-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;pad=
ding:0in 0in 0in 0in">
</td>
</tr>
</tbody>
</table>
</div>
<p class=3D"MsoNormal"><span style=3D"font-size:11.0pt;font-family:&quot;Ca=
libri&quot;,&quot;sans-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span><=
/p>
</div>
<br>
<hr>
<font face=3D"Courier New" color=3D"Gray" size=3D"1">This email and any att=
achments may be confidential and are intended solely for the use of the ind=
ividual to whom it is addressed.<br>
<br>
If you are not the intended recipient of this email, the following stipulat=
ions govern the use of this information: You may not take any action based =
upon its contents. You may not copy or show this message or attachments to =
anyone. You should contact the sender
 and subsequently delete this message and all attachments.<br>
<br>
Any views or opinions expressed are solely those of the author and do not n=
ecessarily represent those of Special Operations Technology, Incorporated.<=
br>
<br>
While antivirus software has been applied, you should perform due diligence=
 to check this email and attachments for the presence of viruses. No warran=
ties or assurances are made in relation to the safety and content of this e=
mail and attachments. Special Operations
 Technology, Incorporated accepts no liability for any damages caused by an=
y virus transmitted by or contained in this email and attachments.<br>
<br>
No liability is accepted for any consequences arising from this email trans=
mission whatsoever.<br>
<br>
Special Operations Technology, Incorporated is a premier IT professional se=
rvices firm focused in the government and law enforcement space.<br>
</font>
</body>
</html>

--_000_3C5E029826A0704DB5998577FCFF46F0095A278CBFdagobah_--


--===============7986468891762001032==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7986468891762001032==--
